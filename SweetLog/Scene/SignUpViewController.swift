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
                owner.mainView.emailMessageLabel.text = isValid ? "" : "@ 포함, 6글자 이상 입력, 중복체크 필요"
                owner.mainView.duplicateCheckButton.isEnabled = isValid
                print(isValid)
            }
            .disposed(by: disposeBag)
        
        output.emailCanUse
            .drive(with: self) { owner, _ in
                owner.mainView.makeToast("", duration: <#T##TimeInterval#>, point: <#T##CGPoint#>, title: <#T##String?#>, image: <#T##UIImage?#>, style: <#T##ToastStyle#>, completion: <#T##((Bool) -> Void)?#>)
            }
            .disposed(by: disposeBag)
        
        output.validPassword
            .drive(with: self) { owner, isValid in
                owner.mainView.passwordMessageLabel.textColor = isValid ? Color.validGreen : Color.validRed
                owner.mainView.passwordMessageLabel.text = isValid ? "" : "5글자 이상 입력해주세요"
            }
            .disposed(by: disposeBag)
        
        output.validNickname
            .drive(with: self) { owner, isValid in
                owner.mainView.nicknameMessageLabel.textColor = isValid ? Color.validGreen : Color.validRed
                owner.mainView.nicknameMessageLabel.text = isValid ? "" : "2글자 이상 입력해주세요"
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "회원가입"
    }
    
    override func loadView() {
        view = mainView
    }

}
