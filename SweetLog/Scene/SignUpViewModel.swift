//
//  SignUpViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: - 이메일 중복확인(버튼 클릭), 이메일, 비밀번호, 닉네임 검증, 회원가입
final class SignUpViewModel: ViewModelType {
    var checkedEmailText: String = ""
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: Observable<String>
        let duplicateCheckButtonTapped: Observable<Void>
        let passwordText: Observable<String>
        let nicknameText: Observable<String>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let validEmail: Driver<Bool>
        let emailCanUse: Driver<Bool>
        let validPassword: Driver<Bool>
        let validNickname: Driver<Bool>
        let totalValid: Driver<Bool>
        let signUpSuccessTrigger: Driver<Void>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        var currentEmailText = ""
        let emailValid = PublishRelay<Bool>()
        let emailCanUse = PublishRelay<Bool>()   // + 중복체크
        let passwordValid = PublishRelay<Bool>()
        let nicknameValid = PublishRelay<Bool>()
        let totalValid = BehaviorRelay(value: false)
        let signUpSuccessTrigger = PublishRelay<Void>()
        let errorString = PublishRelay<String>()
        
        let validObservable = Observable.combineLatest(emailCanUse, passwordValid, nicknameValid)
            .map { $0 && $1 && $2 }
        
        validObservable
            .subscribe(with: self) { owner, isValid in
                totalValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        let signUpObservable = Observable.combineLatest(input.emailText, input.passwordText, input.nicknameText)
            .map { email, password, nickname in
                print(email, password, nickname)
                return JoinQuery(email: email, password: password, nick: nickname)
            }
        
        input.signUpButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap { joinQuery in
                return AuthNetworkManager.shared.createJoin(query: joinQuery)
                    .catch { error in
                        errorString.accept(error.localizedDescription)
                        return Single<JoinModel>.never()
                    }
            }
            .debug()
            .subscribe(with: self) { owner, joinModel in
                signUpSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        
        input.duplicateCheckButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText)
            .map {
                print("클릭")
                let text =  $0.trimmingCharacters(in: [" "])
                return ValidationQuery(email: text)
            }
            .flatMap {
                return AuthNetworkManager.shared.validationEmail(email: $0)
                    .catch { error in
                        print(error.localizedDescription)
                        errorString.accept(error.localizedDescription)
                        emailCanUse.accept(false)
                        return Single<ValidationModel>.never()
                    }
            }
            .debug()
            .subscribe(with: self, onNext: { owner, validationMessage in
                print(validationMessage)
                emailCanUse.accept(true)
                owner.checkedEmailText = currentEmailText
            })
            .disposed(by: disposeBag)
        
        input.emailText
            .map {
                currentEmailText = $0
                let isValid = $0.contains("@") && $0.trimmingCharacters(in: [" "]).count > 6 
                return isValid
            }
            .bind(with: self) { owner, isValid in
                emailValid.accept(isValid)
                if owner.checkedEmailText == currentEmailText {
                    
                } else {
                    emailCanUse.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { $0.trimmingCharacters(in: [" "]).count > 5 }
            .bind(with: self) { owner, isValid in
                passwordValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.nicknameText
            .map { $0.trimmingCharacters(in: [" "]).count > 1 }
            .bind(with: self) { owner, isValid in
                nicknameValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        return Output(validEmail: emailValid.asDriver(onErrorJustReturn: false),
                      emailCanUse: emailCanUse.asDriver(onErrorJustReturn: false),
                      validPassword: passwordValid.asDriver(onErrorJustReturn: false),
                      validNickname: nicknameValid.asDriver(onErrorJustReturn: false),
                      totalValid: totalValid.asDriver(),
                      signUpSuccessTrigger: signUpSuccessTrigger.asDriver(onErrorJustReturn: ()),
                      errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
}
