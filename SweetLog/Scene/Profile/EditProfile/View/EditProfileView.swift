//
//  EditProfileView.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit

final class EditProfileView: BaseView {
    let profileImageView = UIImageView()
    let editProfileImageButton = UIButton()
    let nicknameTextField = UITextField()
    let nicknameValidMessage = UILabel()
    
    let editProfileButton = UIButton()
    
    override func configureHierarchy() {
        addSubviews([profileImageView, editProfileImageButton, nicknameTextField, nicknameValidMessage, editProfileButton])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(120)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        editProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.centerX.equalTo(profileImageView)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(editProfileImageButton.snp.bottom).offset(50)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.height.equalTo(45)
        }
        nicknameValidMessage.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(15)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            make.height.equalTo(50)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        nicknameTextField.layer.addBorder([.bottom], color: Color.black, width: 1)
    }
    
    override func configureView() {
        super.configureView()
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleToFill
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)
        var editImageConfig = UIButton.Configuration.filled()
        editImageConfig.baseBackgroundColor = Color.backgroundGray
        editImageConfig.background.strokeColor = Color.buttonStrokeGray
        editImageConfig.title = "이미지 수정"
        editImageConfig.attributedTitle = AttributedString("이미지 수정", attributes: titleContainer)
        editImageConfig.baseForegroundColor = Color.gray
        editImageConfig.cornerStyle = .capsule
        editProfileImageButton.configuration = editImageConfig
        
        nicknameTextField.placeholder = "닉네임"
        nicknameTextField.borderStyle = .none
        nicknameValidMessage.design(textColor: Color.validRed, font: .pretendard(size: 15, weight: .regular))
        
        editProfileButton.backgroundColor = Color.gray1
        editProfileButton.titleLabel?.textColor = Color.white
        editProfileButton.setTitle("프로필 수정", for: .normal)
        editProfileButton.layer.cornerRadius = 12
        editProfileButton.clipsToBounds = true
    }
}

