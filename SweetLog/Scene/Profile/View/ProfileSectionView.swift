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
    
    private let postInfoStackView = UIStackView()
    let postInfoView = ProfileInfoView()
    let followInfoView = ProfileInfoView()
    let followingInfoView = ProfileInfoView()
    
    let followTapGesture = UITapGestureRecognizer()
    let followingTapGesture  = UITapGestureRecognizer()
    
    let seperatorView = UIView()
    
    // 팔로우 상태 갱신
    func setFollowStatus(status: Bool) {
        guard var followConfig = followButton.configuration else { return }
        followConfig.baseBackgroundColor = status ? Color.backgroundGray : Color.brown
        followConfig.baseForegroundColor = status ? Color.black : Color.white
        followConfig.title = status ? "팔로잉": "팔로우"
        followButton.configuration = followConfig
    }
    
    // 프로필 정보 업데이트
    func updateProfileInfo(_ profileModel: ProfileModel, isMyProfile: Bool) {
        if let profileImageUrl = profileModel.profileImage {
            setProfileImage(imageUrl: profileImageUrl)
        }
        
        followButton.isHidden = isMyProfile
        editProfileButton.isHidden = !isMyProfile
        
        nicknameLabel.text = profileModel.nickname
        emailLabel.text = profileModel.email
        
        postInfoView.countLabel.text = "\(profileModel.posts.count)"
        followInfoView.countLabel.text = "\(profileModel.followers.count)"
        followingInfoView.countLabel.text = "\(profileModel.following.count)"
    }
    
    // 프로필 이미지 설정
    private func setProfileImage(imageUrl: String) {
        profileImageView.kf.setImageWithAuthHeaders(with: imageUrl) { isSuccess in
            if !isSuccess {
                print("프로필 사진 로드 실패")
            }
        }
    }
    
    
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
            nicknameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nicknameLabel)
        }
        
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.greaterThanOrEqualTo(nicknameLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(24)
            followButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
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
        followInfoView.addGestureRecognizer(followTapGesture)
        followInfoView.isUserInteractionEnabled = true
        
        followingInfoView.countLabel.text = "\(0)"
        followingInfoView.titleLabel.text = "팔로잉"
        followingInfoView.addGestureRecognizer(followingTapGesture)
        followingInfoView.isUserInteractionEnabled = true
        
        seperatorView.backgroundColor = Color.gray2
    }
}
