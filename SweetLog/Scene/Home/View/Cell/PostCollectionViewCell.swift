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
        profileImageView.image = Image.emptyProfileImage
        configureCell(fetchPostItem: nil)
    }
    
    func configureCell(fetchPostItem: FetchPostItem?) {
        guard let item = fetchPostItem else { return }
        setProfileImage(url: item.creator.profileImage)
        userNicknameLabel.text = item.creator.nickname
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(item.createdAt)
        contentLabel.text = item.review
        
        likeInfoView.countLabel.text = "\(item.likes.count)"
        commentInfoView.countLabel.text = "\(item.comments.count)"
        
        setImageUI(files: item.files)
    }
    
    private func setProfileImage(url: String?) {
        if let profileImageUrl = url {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { [weak self] isSuccess in
                guard let self else { return }
                if !isSuccess {
                    self.profileImageView.image = Image.emptyProfileImage
                }
            }
        }
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
    
    // 이미지 한개일 때
    private func setOneImage(files: [String]) {
        guard let imageUrl = files.first else {
            return
        }
        let imageView = PostImageView(frame: .zero)
       
        imageView.kf.setImageWithAuthHeaders(with: imageUrl) { isSuccess in
            if !isSuccess {
                imageView.backgroundColor = Color.gray
            }
        }
        imageStackView.addArrangedSubview(imageView)
        
        
    }
    
    private func setTwoImage(files: [String]) {
        guard let firstImageUrl = files.first else {
            return
        }
        let secondImageUrl = files[1]
        
        let firstImageView = PostImageView(frame: .zero)
        let secondImageView = PostImageView(frame: .zero)
       
        firstImageView.kf.setImageWithAuthHeaders(with: firstImageUrl) { isSuccess in
            if !isSuccess {
                firstImageView.backgroundColor = .black
            }
        }
        secondImageView.kf.setImageWithAuthHeaders(with: secondImageUrl) { isSuccess in
            if !isSuccess {
                secondImageView.backgroundColor = .black
            }
        }
        imageStackView.addArrangedSubview(firstImageView)
        imageStackView.addArrangedSubview(secondImageView)
        
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(136.0 / 163.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(136.0 / 102.0)
        }
    }
    private func setThreeImage(files: [String]) {
        guard let firstImageUrl = files.first else {
            return
        }
        let secondImageUrl = files[1]
        let thridImageUrl = files[2]
        
        let firstImageView = PostImageView(frame: .zero)
        let secondImageView = PostImageView(frame: .zero)
        let thirdImageView = PostImageView(frame: .zero)
       
        firstImageView.kf.setImageWithAuthHeaders(with: firstImageUrl) { isSuccess in
            if !isSuccess {
                firstImageView.backgroundColor = .black
            }
        }
        secondImageView.kf.setImageWithAuthHeaders(with: secondImageUrl) { isSuccess in
            if !isSuccess {
                secondImageView.backgroundColor = .black
            }
        }
        thirdImageView.kf.setImageWithAuthHeaders(with: thridImageUrl) { isSuccess in
            if !isSuccess {
                thirdImageView.backgroundColor = .black
            }
        }
        
        var imageVStackView = UIStackView()
        imageVStackView.axis = .vertical
        imageVStackView.alignment = .fill
        imageVStackView.distribution = .fill
        imageVStackView.spacing = 4
        
        imageStackView.addArrangedSubview(firstImageView)
        imageStackView.addArrangedSubview(imageVStackView)
        
        [secondImageView, thirdImageView].forEach {
            imageVStackView.addArrangedSubview($0)
        }
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(imageVStackView.snp.width).multipliedBy(163.0 / 136.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(66.0 / 102.0)
        }
        
        thirdImageView.snp.makeConstraints {
            $0.height.equalTo(thirdImageView.snp.width).multipliedBy(66.0 / 102.0)
        }
        
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, userNicknameLabel, createdAtLabel, contentLabel, imageStackView, likeInfoView, commentInfoView])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.size.equalTo(36)
        }
        
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
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
            make.height.greaterThanOrEqualTo(16)
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
            make.width.equalTo(40)
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
        DispatchQueue.main.async {
            self.imageStackView.layer.cornerRadius = 6
            self.imageStackView.clipsToBounds = true
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = Color.white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleAspectFill
        
        imageStackView.spacing = 4
        imageStackView.alignment = .fill
        imageStackView.distribution = .equalSpacing
        imageStackView.layer.cornerRadius = 12
    }
}
