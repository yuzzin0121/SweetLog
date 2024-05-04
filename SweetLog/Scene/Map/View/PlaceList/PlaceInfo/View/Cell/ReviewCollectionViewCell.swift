//
//  ReviewCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import UIKit

class ReviewCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let createdAtLabel = UILabel()
    private let imageScrollView = UIScrollView()
    private var imageStackView = UIStackView()
    private var reviewLabel = UILabel()
    private var hashtagLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(postItem: nil)
        imageStackView = UIStackView()
        profileImageView.image = Image.emptyProfileImage
    }
    
    func configureCell(postItem: FetchPostItem?) {
        guard let postItem else { return }
        setProfileImage(url: postItem.creator.profileImage)
        nicknameLabel.text = postItem.creator.nickname
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(postItem.createdAt)
        reviewLabel.text = String.unTaggedText(text: postItem.review)
        reviewLabel.addCharacterSpacing()
        setImages(files: postItem.files)
        
        hashtagLabel.text = String.getListToString(array: postItem.hashTags)
    }
    
    private func setImages(files: [String]) {
        for file in files {
            let imageView = PhotoImageView(frame: .zero)
            imageView.kf.setImageWithAuthHeaders(with: file) { isSuccess in
                if !isSuccess {
                    print("이미지 로드 에러")
                }
            }
            imageStackView.addArrangedSubview(imageView)
            if files.count == 1 {
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(UIScreen.main.bounds.width - 40)
                    make.height.equalTo(200)
                }
            } else {
                imageView.snp.makeConstraints { make in
                    make.width.equalTo(250)
                    make.height.equalTo(200)
                }
            }
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
        }
    }
    
    private func setProfileImage(url: String?) {
        guard let url else { return }
        profileImageView.kf.setImageWithAuthHeaders(with: url) { isSuccess in
            if !isSuccess {
                print("프로필 이미지 로드 에러")
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, nicknameLabel, createdAtLabel, imageScrollView, reviewLabel, hashtagLabel])
        imageScrollView.addSubview(imageStackView)
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(36)
        }
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nicknameLabel)
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        imageStackView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.edges.equalTo(imageScrollView)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    override func configureView() {
        profileImageView.image = Image.emptyProfileImage
        nicknameLabel.design(font: .pretendard(size: 16, weight: .semiBold))
        createdAtLabel.design(textColor: Color.gray, font: .pretendard(size: 12, weight: .light))
        reviewLabel.design(font: .pretendard(size: 14, weight: .light))
        hashtagLabel.design(textColor: Color.brown, font: .pretendard(size: 14, weight: .light), numberOfLines: 0)
        imageScrollView.showsHorizontalScrollIndicator = false
        imageStackView.spacing = 4
        imageStackView.isUserInteractionEnabled = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
    }
}
