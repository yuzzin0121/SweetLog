//
//  FollowDetailTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit
import RxSwift

class FollowDetailTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let followButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        profileImageView.image = Image.emptyProfileImage
        configureCell(user: nil, followType: nil, isMyProfile: nil, following: nil)
    }
    
    func configureCell(user: User?, followType: FollowType?, isMyProfile: Bool?, following: [User]?) {
        guard let user,  let followType, let isMyProfile, let following else { return }
        if let profileImageUrl = user.profileImage {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { isSuccess in
                if !isSuccess {
                    print("프로필 사진 로드 실패")
                }
            }
        }
        
        nicknameLabel.text = user.nick
        let followingUserIdList = following.map { $0.user_id }
        
        if followType == .follow && isMyProfile {
            followButton.isHidden = true    // 팔로우 버튼 안보이게
        } else if followType == .following && isMyProfile {
            setFollowStatus(status: true)
        } else {
            if user.user_id == UserDefaultManager.shared.userId {    // 유저가 나일 경우
                followButton.isHidden = true
            } else if followingUserIdList.contains(user.user_id) {   // 내가 팔로잉하는 유저일 경우
                setFollowStatus(status: true)
            } else if followingUserIdList.contains(user.user_id) {
                setFollowStatus(status: false)
            }
        }
        
    }
    
    func setFollowStatus(status: Bool) {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 14)
        
        guard var followConfig = followButton.configuration else { return }
        followConfig.baseBackgroundColor = status ? Color.backgroundGray : Color.brown
        followConfig.baseForegroundColor = status ? Color.black : Color.white
        
        let title = status ? "팔로잉": "팔로우"
        followConfig.title = title
        followConfig.attributedTitle = AttributedString(title, attributes: titleContainer)
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
        followConfig.baseBackgroundColor = Color.brown
        followConfig.baseForegroundColor = Color.white
        followConfig.title = "팔로우"
        followConfig.attributedTitle = AttributedString("팔로우", attributes: titleContainer)
        followConfig.cornerStyle = .capsule
        followButton.configuration = followConfig
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
}
