//
//  SignInViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class SignInViewController: BaseViewController {
    let mainView = SignInView()
    
    let viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func bind() {
        
        let input = SignInViewModel.Input(
            emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
            passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
            signUpButtonTapped: mainView.signInButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.signInValidation
            .drive(with: self) { owner, isValid in
                owner.mainView.signInButton.isEnabled = isValid
                owner.mainView.signInButton.backgroundColor = isValid ? Color.brown : Color.gray
            }
            .disposed(by: disposeBag)
        
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.changeHome()
            }
            .disposed(by: disposeBag)
        
        mainView.signUpButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSignUpVC()
            }
            .disposed(by: disposeBag)
        
        output.errorString
            .drive(with: self) { owner, errorMessage in
                owner.mainView.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)
    }
    
    private func showSignUpVC() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
}
