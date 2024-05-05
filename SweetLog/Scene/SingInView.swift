//
//  SingInView.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import UIKit

final class SignInView: BaseView {
    let logoLabel = UILabel()
    let emailTextField = SignTextField(placeholderText: "이메일")
    let passwordTextField = SignTextField(placeholderText: "비밀번호")
    let signInButton = SignButton(title: "로그인")
    let signUpButton = SignButton(title: "회원가입")
    
    override func configureHierarchy() {
        addSubviews([logoLabel, emailTextField, passwordTextField, signInButton, signUpButton])
    }
    override func configureLayout() {
        logoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(150)
            make.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(55)
            make.top.equalTo(logoLabel.snp.bottom).offset(100)
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
        
        passwordTextField.isSecureTextEntry = true
        
        logoLabel.text = "달콤로그"
        logoLabel.font = .pretendard(size: 30, weight: .extraBold)
    }
}
