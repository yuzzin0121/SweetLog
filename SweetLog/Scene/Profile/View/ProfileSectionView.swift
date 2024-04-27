//
//  ProfileView.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import UIKit

final class ProfileSectionView: BaseView {
    let profileImageView = UIImageView()
    let editProfileButton = UIButton()
    
    let nicknameLabel = UILabel()
    let emailLabel = UILabel()
    let followButton = UIButton()
    
    let postInfoStackView = UIStackView()
    let postInfoView = ProfileInfoView()
    let followInfoView = ProfileInfoView()
    let followingInfoView = ProfileInfoView()
    
    let seperatorView = UIView()
    
    override func configureHierarchy() {
        addSubviews([profileImageView, editProfileButton, nicknameLabel, emailLabel, followButton, postInfoStackView, seperatorView])
        [postInfoView, followInfoView, followingInfoView].forEach {
            postInfoStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(32)
            make.size.equalTo(80)
        }
        
        editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalTo(profileImageView)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(50)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nicknameLabel)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        postInfoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.leading.equalTo(nicknameLabel)
            make.bottom.equalTo(editProfileButton.snp.bottom)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(8)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
            profileImageView.clipsToBounds = true
        }
    }
    
    override func configureView() {
        super.configureView()
        profileImageView.image = Image.emptyProfileImage
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)
        var editConfig = UIButton.Configuration.filled()
        editConfig.baseBackgroundColor = Color.backgroundGray
        editConfig.background.strokeColor = Color.buttonStrokeGray
        editConfig.title = "프로필 수정"
        editConfig.attributedTitle = AttributedString("프로필 수정", attributes: titleContainer)
        editConfig.baseForegroundColor = Color.gray
        editConfig.cornerStyle = .capsule
        editProfileButton.configuration = editConfig
        
        nicknameLabel.design(text: "닉네임", font: .pretendard(size: 20, weight: .semiBold))
        emailLabel.design(text: "asdf@sesac.com", font: .pretendard(size: 15, weight: .light))
        
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)

        var followConfig = UIButton.Configuration.filled()
        followConfig.baseBackgroundColor = Color.backgroundGray
        followConfig.baseForegroundColor = Color.black
        followConfig.title = "팔로우"
        followConfig.attributedTitle = AttributedString("팔로우", attributes: titleContainer)
        followConfig.cornerStyle = .capsule
        followButton.configuration = followConfig
        
        postInfoStackView.design(axis: .horizontal, alignment: .fill, distribution: .equalCentering)
        
        postInfoView.countLabel.text = "\(0)"
        postInfoView.titleLabel.text = "후기"
        
        followInfoView.countLabel.text = "\(0)"
        followInfoView.titleLabel.text = "팔로우"
        
        followingInfoView.countLabel.text = "\(0)"
        followingInfoView.titleLabel.text = "팔로잉"
        
        seperatorView.backgroundColor = Color.gray2
    }
}
