//
//  PostCommentTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/26/24.
//

import UIKit

final class PostCommentTableViewCell: BaseTableViewCell {
    let profileImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    let commentLabel = UILabel()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        configureCell(comment: nil)
    }
    
    func configureCell(comment: Comment?) {
        guard let comment else { return }
        if let profileImageUrl = comment.creator.profileImage {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { [weak self] isSuccess in
                guard let self else { return }
                if !isSuccess {
                    profileImageView.image = Image.emptyProfileImage
                }
            }
        } else {
            profileImageView.image = Image.emptyProfileImage
        }
        
        nicknameLabel.text = comment.creator.nickname
        dateLabel.text = DateFormatterManager.shared.formattedUpdatedDate(comment.createdAt)
        commentLabel.text = comment.content
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, nicknameLabel, dateLabel, commentLabel])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(2)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.height.equalTo(12)
        }
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel)
            make.leading.equalTo(nicknameLabel.snp.trailing).offset(4)
            make.height.equalTo(11)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nicknameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(14)
        }
    }
    override func configureView() {
        profileImageView.image = Image.emptyProfileImage
        
        nicknameLabel.design(text: "닉넴", font: .pretendard(size: 12, weight: .light))
        dateLabel.design(text: "날짜", font: .pretendard(size: 11, weight: .light))
        commentLabel.design(text: "댓글댓글댓글댓글댓글댓글댓글댓글댓글댓글", font: .pretendard(size: 14, weight: .regular))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.clipsToBounds = true
        }
    }
}
