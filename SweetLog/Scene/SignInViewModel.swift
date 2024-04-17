//
//  SignInViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: - 회원가입버튼 클릭, 이메일, 비밀번호 로그인
final class SignInViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: Observable<String>
        let passwordText: Observable<String>
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        let signInValidation: Driver<Bool>
        let loginSuccessTrigger: Driver<Void>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let loginValid = BehaviorRelay(value: false)
        let loginSuccessTrigger = PublishRelay<Void>()
        let errorString = PublishRelay<String>()
        
        let loginObservable = Observable.combineLatest(
            input.emailText,
            input.passwordText
        )
            .map { email, password in
                return LoginQuery(email: email, password: password)
            }
        
        loginObservable
            .bind(with: self) { owner, login in
                if login.email.contains("@") && login.password.count > 3 {
                    loginValid.accept(true)
                } else {
                    loginValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { loginQuery in
                return AuthNetworkManager.createLogin(query: loginQuery)
                    .catch { error in
                        print(error.localizedDescription)
                        errorString.accept(error.localizedDescription)
                        return Single<LoginModel>.never()
                    }
            }
            .subscribe(with: self) { owner, loginModel in
                print("로그인 성공")
                owner.saveUserInfo(userId: loginModel.userId,
                             accessToken: loginModel.accessToken,
                             refreshToken: loginModel.refreshToken)
                loginSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)

        
        
        return Output(
            signInValidation: loginValid.asDriver(),
            loginSuccessTrigger: loginSuccessTrigger.asDriver(onErrorJustReturn: ()), 
            errorString: errorString.asDriver(onErrorJustReturn: "")
        )
    }
    
    private func saveUserInfo(userId: String, accessToken: String, refreshToken: String) {
        UserDefaultManager.shared.userId = userId
        UserDefaultManager.shared.accessToken = accessToken
        UserDefaultManager.shared.refreshToken = refreshToken
    }
}
