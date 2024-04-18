//
//  SignUpView.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import UIKit

final class SignUpView: BaseView {
    let emailLabel = SignLabel(title: "이메일")
    let emailTextField = SignTextField(placeholderText: "이메일")
    let emailMessageLabel = UILabel()
    let duplicateCheckButton = UIButton()
    
    let passwordLabel = SignLabel(title: "비밀번호")
    let passwordTextField = SignTextField(placeholderText: "비밀번호")
    let passwordMessageLabel = UILabel()
    
    let nicknameLabel = SignLabel(title: "닉네임")
    let nicknameTextField = SignTextField(placeholderText: "닉네임")
    let nicknameMessageLabel = UILabel()
    let signUpButton = SignButton(title: "회원가입")
    
    override func configureHierarchy() {
        addSubviews([emailLabel, emailTextField, duplicateCheckButton, emailMessageLabel,
                     passwordLabel, passwordTextField, passwordMessageLabel,
                     nicknameLabel, nicknameTextField, nicknameMessageLabel,
                     signUpButton])
    }
    override func configureLayout() {
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(150)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(17)
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(emailLabel.snp.bottom).offset(12)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(duplicateCheckButton.snp.leading).offset(-16)
        }
        duplicateCheckButton.snp.makeConstraints { make in
            make.top.equalTo(emailTextField)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(55)
            make.width.equalTo(80)
        }
        emailMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(14)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(emailMessageLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(17)
        }
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(passwordLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        passwordMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(14)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordMessageLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(17)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        nicknameMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(14)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.greaterThanOrEqualTo(nicknameMessageLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    override func configureView() {
        super.configureView()
        duplicateCheckButton.backgroundColor = Color.borderGray
        duplicateCheckButton.setTitle("중복체크", for: .normal)
        duplicateCheckButton.setTitleColor(Color.black, for: .normal)
        duplicateCheckButton.titleLabel?.font = .pretendard(size: 15, weight: .semiBold)
        duplicateCheckButton.layer.cornerRadius = 12
        
        emailMessageLabel.font = .pretendard(size: 14, weight: .regular)
        passwordMessageLabel.font = .pretendard(size: 14, weight: .regular)
        nicknameMessageLabel.font = .pretendard(size: 14, weight: .regular)
    }
}
