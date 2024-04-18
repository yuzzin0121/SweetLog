//
//  SingInView.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation

final class SignInView: BaseView {
    let emailTextField = SignTextField(placeholderText: "이메일")
    let passwordTextField = SignTextField(placeholderText: "비밀번호")
    let signInButton = SignButton(title: "로그인")
    let signUpButton = SignButton(title: "회원가입")
    
    override func configureHierarchy() {
        addSubviews([emailTextField, passwordTextField, signInButton, signUpButton])
    }
    override func configureLayout() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(safeAreaLayoutGuide).offset(250)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
    override func configureView() {
        super.configureView()
        signUpButton.backgroundColor = Color.white
        signUpButton.setTitleColor(Color.brown, for: .normal)
        signUpButton.layer.borderColor = Color.brown.cgColor
        signUpButton.layer.borderWidth = 1
    }
}
