//
//  SignUpViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import Toast

final class SignUpViewController: BaseViewController {
    let mainView = SignUpView()
    
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func bind() {
        let input = SignUpViewModel.Input(emailText: mainView.emailTextField.rx.text.orEmpty.asObservable(),
                                          duplicateCheckButtonTapped: mainView.duplicateCheckButton.rx.tap.asObservable(),
                                          passwordText: mainView.passwordTextField.rx.text.orEmpty.asObservable(),
                                          nicknameText: mainView.nicknameTextField.rx.text.orEmpty.asObservable(),
                                          signUpButtonTapped: mainView.signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.validEmail
            .drive(with: self) { owner, isValid in
                owner.mainView.emailMessageLabel.textColor = isValid ? Color.validGreen : Color.validRed
                owner.mainView.emailMessageLabel.text = isValid ? "" : "@ 포함, 6글자 이상 입력"
                owner.mainView.duplicateCheckButton.isEnabled = isValid
                print(isValid)
            }
            .disposed(by: disposeBag)
        
        output.emailCanUse
            .drive(with: self) { owner, canUse in
                if canUse {
                    owner.mainView.makeToast("사용 가능한 이메일입니다.")
                    owner.mainView.emailMessageLabel.text = ""
                }
            }
            .disposed(by: disposeBag)
        
        output.validPassword
            .drive(with: self) { owner, isValid in
                owner.mainView.passwordMessageLabel.textColor = isValid ? Color.validGreen : Color.validRed
                owner.mainView.passwordMessageLabel.text = isValid ? "" : "5~14글자로 입력"
            }
            .disposed(by: disposeBag)
        
        output.validNickname
            .drive(with: self) { owner, isValid in
                owner.mainView.nicknameMessageLabel.textColor = isValid ? Color.validGreen : Color.validRed
                owner.mainView.nicknameMessageLabel.text = isValid ? "" : "2~7글자로 입력"
            }
            .disposed(by: disposeBag)
        
        output.errorString
            .drive(with: self) { owner, errorMessage in
                owner.mainView.makeToast(errorMessage)
            }
            .disposed(by: disposeBag)
        
        output.totalValid
            .drive(with: self) { owner, isValid in
                owner.mainView.signUpButton.isEnabled = isValid
                owner.mainView.signUpButton.backgroundColor = isValid ? Color.brown : Color.gray
            }
            .disposed(by: disposeBag)
        
        output.signUpSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.successSignUp()
            }
            .disposed(by: disposeBag)
    }
    
    private func successSignUp() {
        mainView.makeToast("로그인하였습니다", duration: 0.5) { [weak self] didTap in
            guard let self else { return }
            popView()
        }
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "회원가입"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }
    
    override func loadView() {
        view = mainView
    }

}
