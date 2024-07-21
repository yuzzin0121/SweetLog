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
    let updatedAtLabel = UILabel()
    
    func configureCell(chatRoom: ChatRoom) {
        let user = chatRoom.participants[1]
        setProfileImage(user: user)
        nicknameLabel.text = user.nick
        updatedAtLabel.text = DateFormatterManager.shared.formattedDate(chatRoom.updatedAt)
        guard let lastChat = chatRoom.lastChat else {
            return
        }
        contentLabel.text = lastChat.content
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
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.4
        profileImageView.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        [profileImageView, stackView, updatedAtLabel].forEach {
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
            make.width.equalTo(profileImageView.snp.height)
        }
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
        updatedAtLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.trailing.equalToSuperview()
        }
    }
    
    override func configureView() {
        stackView.axis = .vertical
        stackView.spacing = 6
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleAspectFill
        nicknameLabel.design(font: .pretendard(size: 15, weight: .semiBold))
        contentLabel.design(text: "", font: .pretendard(size: 14, weight: .light))
        updatedAtLabel.design(textColor: .gray5, font: .pretendard(size: 12, weight: .regular))
    }
}
