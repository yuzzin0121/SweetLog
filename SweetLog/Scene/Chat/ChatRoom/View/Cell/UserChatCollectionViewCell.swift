//
//  UserChatCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 7/22/24.
//

import UIKit

final class UserChatCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    
    private let stackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let contentBackgroundView = UIView()
    private let contentLabel = UILabel()
    private let createdAtLabel = UILabel()
    
    
    func configureCell(chat: Chat) {
        setProfileImageView(chat.sender.profileImage)
        nicknameLabel.text = chat.sender.nick
        contentLabel.text = chat.content
        createdAtLabel.text = DateFormatterManager.shared.formattedDate(chat.createdAt)
    }
    
    private func setProfileImageView(_ image: String?) {
        guard let image else {
            profileImageView.image = Image.emptyProfileImage
            return
        }
        profileImageView.kf.setImageWithAuthHeaders(with: image) { [weak self] isSuccess in
            guard let self else { return }
            if !isSuccess {
                profileImageView.image = Image.emptyProfileImage
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(createdAtLabel)
        [nicknameLabel, contentBackgroundView].forEach {
            stackView.addArrangedSubview($0)
        }
        contentBackgroundView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.bottom.greaterThanOrEqualToSuperview()
        }
    
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentBackgroundView.snp.bottom)
            make.leading.equalTo(stackView.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-60)
        }
    }
    
    override func configureView() {
        stackView.design(axis: .vertical, spacing: 4)
        profileImageView.image = Image.emptyProfileImage
        nicknameLabel.design(font: .pretendard(size: 15, weight: .light))
        contentLabel.design(font: .pretendard(size: 16, weight: .regular), numberOfLines: 0)
        createdAtLabel.design(textColor: Color.gray4, font: .pretendard(size: 12, weight: .regular))
        contentBackgroundView.backgroundColor = Color.sugarBrown
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.5
        profileImageView.clipsToBounds = true
        contentBackgroundView.layer.cornerRadius = 12
        contentBackgroundView.clipsToBounds = true
    }
}
