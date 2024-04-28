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
        configureCell(user: nil, type: nil)
    }
    
    func configureCell(user: User?, type: FollowType?) {
        guard let user, let type else { return }
        if let profileImageUrl = user.profileImage {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { isSuccess in
                if !isSuccess {
                    print("프로필 사진 로드 실패")
                }
            }
        }
        
        nicknameLabel.text = user.nickname
        switch type {
        case .follow:
            followButton.isHidden = true
        case .following:
            followButton.configuration?.title = "팔로잉"
        }
        
    }

    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, nicknameLabel, followButton])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
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
        nicknameLabel.design(text: "닉네임", font: .pretendard(size: 16, weight: .semiBold))
        
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
}
