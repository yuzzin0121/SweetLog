//
//  FollowDetailTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit

class FollowDetailTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let followButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = Image.emptyProfileImage
        configureCell(user: nil, type: nil, isMyProfile: nil)
    }
    
    func configureCell(user: User?, type: FollowType?, isMyProfile: Bool?) {
        guard let user, let type, let isMyProfile else { return }
        if let profileImageUrl = user.profileImage {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { isSuccess in
                if !isSuccess {
                    print("프로필 사진 로드 실패")
                }
            }
        }
        
        nicknameLabel.text = user.nickname
        
        if type == .follow && isMyProfile {
            followButton.isHidden = true    // 팔로우 버튼 안보이게
        } else if type == .following && isMyProfile {
            setFollowStatus(status: true)
        } else {
            if user.userId == UserDefaultManager.shared.userId {    // 유저가 나일 경우
                followButton.isHidden = true
            } else if UserDefaultManager.shared.following.contains(user.userId) {   // 내가 팔로잉하는 유저일 경우
                setFollowStatus(status: true)
            } else if !UserDefaultManager.shared.following.contains(user.userId) {
                setFollowStatus(status: false)
            }
        }
        
    }
    
    func setFollowStatus(status: Bool) {
        guard var followConfig = followButton.configuration else { return }
        followConfig.baseBackgroundColor = status ? Color.backgroundGray : Color.brown
        followConfig.baseForegroundColor = status ? Color.black : Color.white
        followConfig.title = status ? "팔로잉": "팔로우"
        followButton.configuration = followConfig
    }

    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, nicknameLabel, followButton])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        followButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    override func configureView() {
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleAspectFit
        nicknameLabel.design(text: "닉네임", font: .pretendard(size: 15, weight: .semiBold))
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)
        
        var followConfig = UIButton.Configuration.filled()
        followConfig.baseBackgroundColor = Color.backgroundGray
        followConfig.baseForegroundColor = Color.black
        followConfig.title = "팔로우"
        followConfig.attributedTitle = AttributedString("팔로우", attributes: titleContainer)
        followConfig.cornerStyle = .capsule
        followButton.configuration = followConfig
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.clipsToBounds = true
//        }
    }
}
