//
//  PostCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import UIKit
import Kingfisher

final class PostCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let createdAtLabel = UILabel()
    private let contentLabel = UILabel()
    
    private var imageStackView = UIStackView()
    
    private var likeInfoView = PostInfoView(image: Image.heart, count: 0)
    private var commentInfoView = PostInfoView(image: Image.messages, count: 0)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageStackView = UIStackView()
        configureCell(fetchPostItem: nil)
    }
    
    func configureCell(fetchPostItem: FetchPostItem?) {
        guard let item = fetchPostItem else { return }
        userNicknameLabel.text = item.creator.nickname
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(item.createdAt)
        contentLabel.text = item.content
        
        likeInfoView.countLabel.text = "\(item.likes.count)"
        commentInfoView.countLabel.text = "\(item.comments.count)"
        
        setImageUI(files: item.files)
    }
    
    private func setImageUI(files: [String]) {
        switch files.count {
        case 0...1:
            setOneImage(files: files)
        case 2:
            setTwoImage(files: files)
        case 3...:
            setThreeImage(files: files)
        default:
            setOneImage(files: files)
        }
    }
    
    private func setOneImage(files: [String]) {
        let imageView = UIImageView()
//        imageView.kf.setImageWithAuthHeaders(with: <#T##(any Resource)?#>)
//        imageStackView.
    }
    
    private func setTwoImage(files: [String]) {
        
        
    }
    private func setThreeImage(files: [String]) {
        
        
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, userNicknameLabel, createdAtLabel, contentLabel, imageStackView, likeInfoView, commentInfoView])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.size.equalTo(45)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.height.equalTo(20)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(userNicknameLabel.snp.trailing).offset(6)
            make.centerY.equalTo(userNicknameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).offset(8)
            make.leading.equalTo(userNicknameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.leading.equalTo(userNicknameLabel)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
        
        likeInfoView.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(12)
            make.leading.equalTo(userNicknameLabel)
            make.bottom.equalToSuperview().inset(16)
        }
        
        commentInfoView.snp.makeConstraints { make in
            make.top.equalTo(likeInfoView)
            make.leading.equalTo(likeInfoView.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(16)
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = Color.white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleAspectFill
        
    }
}
