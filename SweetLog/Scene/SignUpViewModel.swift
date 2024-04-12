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
        let validPassword: Driver<Bool>
        let validNickname: Driver<Bool>
        let signUpSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let emailValid = BehaviorRelay(value: false)
        let emailCanUse = BehaviorRelay(value: false)   // + 중복체크
        let passwordValid = BehaviorRelay(value: false)
        let nicknameValid = BehaviorRelay(value: false)
        let signUpSuccessTrigger = PublishRelay<Void>()
        
        input.duplicateCheckButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.emailText)
            .map {
                print("클릭")
                let text =  $0.trimmingCharacters(in: [" "])
                return ValidationQuery(email: text)
            }
            .flatMap {
                return NetworkManager.validationEmail(email: $0)
                    .catch { error in
                        return Single<ValidationModel>.never()
                    }
            }
            .debug()
            .subscribe(with: self, onNext: { owner, validationMessage in
                print(validationMessage)
                emailCanUse.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.emailText
            .map { $0.contains("@") && $0.count > 6 }
            .bind(with: self) { owner, isValid in
                emailValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.passwordText
            .map { $0.count > 5 }
            .bind(with: self) { owner, isValid in
                passwordValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        input.nicknameText
            .map { $0.count > 2 }
            .bind(with: self) { owner, isValid in
                nicknameValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        return Output(validEmail: emailValid.asDriver(), validPassword: passwordValid.asDriver(), validNickname: nicknameValid.asDriver(), signUpSuccessTrigger: signUpSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
