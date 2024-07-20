//
//  ChatRoomTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import UIKit

final class ChatRoomTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let stackView = UIStackView()
    let nicknameLabel = UILabel()
    let contentLabel = UILabel()
    let createdAtLabel = UILabel()
    
    func configureCell(chatRoom: ChatRoom) {
        guard let lastChat = chatRoom.lastChat else { return }
        setProfileImage(user: lastChat.sender)
        nicknameLabel.text = lastChat.sender.nick
        contentLabel.text = lastChat.content
        createdAtLabel.text = DateFormatterManager.shared.formattedDate(lastChat.createdAt)
    }
    
    private func setProfileImage(user: User) {
        guard let imageUrl = user.profileImage else { return }
        profileImageView.kf.setImageWithAuthHeaders(with: imageUrl) { [weak self] isSuccess in
            guard let self else { return }
            if !isSuccess {
                profileImageView.image = Image.emptyProfileImage
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = 5
    }
    
    override func configureHierarchy() {
        [profileImageView, stackView, createdAtLabel].forEach {
            contentView.addSubview($0)
        }
        [nicknameLabel, contentLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalToSuperview()
            make.size.equalTo(40)
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        profileImageView.image = Image.emptyProfileImage
        nicknameLabel.design(font: .pretendard(size: 15, weight: .semiBold))
        contentLabel.design(font: .pretendard(size: 14, weight: .light))
        createdAtLabel.design(textColor: .gray, font: .pretendard(size: 13, weight: .regular))
    }
}
