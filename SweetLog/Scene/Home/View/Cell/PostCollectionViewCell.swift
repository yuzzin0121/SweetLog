//
//  PostCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import UIKit
import Kingfisher
import RxSwift

final class PostCollectionViewCell: BaseCollectionViewCell {
    let profileImageView = UIImageView()
    let userNicknameButton = UIButton()
    private let createdAtLabel = UILabel()
    private let contentLabel = UILabel()
    
    private var imageStackView = UIStackView()
    
    var likeInfoView = PostInfoView(image: Image.heart, count: 0)
    var likeButton = UIButton()
    private var commentInfoView = PostInfoView(image: Image.messages, count: 0)
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
        imageStackView.arrangedSubviews.forEach {
//            imageStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        print(imageStackView.arrangedSubviews.count)
        profileImageView.image = Image.emptyProfileImage
        configureCell(fetchPostItem: nil)
    }
    
    func configureCell(fetchPostItem: FetchPostItem?) {
        guard let item = fetchPostItem else { return }
        setProfileImage(url: item.creator.profileImage)
        
        userNicknameButton.configuration?.title = item.creator.nickname
        
        var titleContainer = AttributeContainer()
        titleContainer.font = .pretendard(size: 16, weight: .semiBold)
        userNicknameButton.configuration?.attributedTitle = AttributedString(item.creator.nickname, attributes: titleContainer)
        
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(item.createdAt)
        
        contentLabel.text = item.review
        
        // Label Dynamic Height
//        let newSize = contentLabel.sizeThatFits(CGSize(width: imageStackView.frame.width, height: CGFloat.greatestFiniteMagnitude))
//        contentLabel.snp.makeConstraints { make in
//            make.height.equalTo(newSize.height)
//        }
       
        likeButton.configuration?.title = "\(item.likes.count)"
        commentInfoView.countLabel.text = "\(item.comments.count)"
        
        setImageUI(files: item.files)
        
        let ifILike = item.likes.contains(UserDefaultManager.shared.userId)
        likeButton.isSelected = ifILike
        likeButton.configuration?.baseForegroundColor = ifILike ? Color.brown2 : Color.gray
        likeButton.configuration?.image = ifILike ? Image.heartFill.resized(to: CGSize(width: 20, height: 20)) : Image.heart.resized(to: CGSize(width: 20, height: 20))
    }
    
    private func setProfileImage(url: String?) {
        if let profileImageUrl = url {
            profileImageView.kf.setImageWithAuthHeaders(with: profileImageUrl) { [weak self] isSuccess in
                guard let self else { return }
                if !isSuccess {
                    print("프로필 이미지 로드 실패")
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
        self.imageStackView.addArrangedSubview(imageView)
       
        DispatchQueue.main.async {
            imageView.kf.setImageWithAuthHeaders(with: imageUrl) { isSuccess in
                if !isSuccess {
                    print("이미지 하나일때 로드 실패")
                    imageView.image = nil
                }
            }
            imageView.layer.cornerRadius = 8
        }
        DispatchQueue.main.async {
            imageView.layer.cornerRadius = 6
            imageView.clipsToBounds = true
        }
    }
    
    private func setTwoImage(files: [String]) {
        guard let firstImageUrl = files.first else {
            return
        }
        let secondImageUrl = files[1]
        
        let firstImageView = PostImageView(frame: .zero)
        let secondImageView = PostImageView(frame: .zero)
        
        imageStackView.addArrangedSubview(firstImageView)
        imageStackView.addArrangedSubview(secondImageView)
        
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(160.0 / 163.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(126.0 / 92.0)
        }
       
        DispatchQueue.main.async {
            firstImageView.kf.setImageWithAuthHeaders(with: firstImageUrl) { isSuccess in
                if !isSuccess {
                    print("이미지 두개일때 1로드 실패")
                    firstImageView.image = nil
                }
            }
        }
        
        DispatchQueue.main.async {
            secondImageView.kf.setImageWithAuthHeaders(with: secondImageUrl) { isSuccess in
                if !isSuccess {
                    print("이미지 두개일때 2로드 실패")
                    secondImageView.image = nil
                }
            }
        }
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 6
            secondImageView.layer.cornerRadius = 6
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
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
        
        let imageVStackView = UIStackView()
        imageVStackView.axis = .vertical
        imageVStackView.alignment = .fill
        imageVStackView.distribution = .fill
        imageVStackView.spacing = 5
        
        imageStackView.addArrangedSubview(firstImageView)
        imageStackView.addArrangedSubview(imageVStackView)
        
        [secondImageView, thirdImageView].forEach {
            imageVStackView.addArrangedSubview($0)
        }
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(imageVStackView.snp.width).multipliedBy(163.0 / 120.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(80.0 / 122.0)
        }
        
        thirdImageView.snp.makeConstraints {
            $0.height.equalTo(thirdImageView.snp.width).multipliedBy(80.0 / 122.0)
        }
        
       
        DispatchQueue.main.async {
            firstImageView.kf.setImageWithAuthHeaders(with: firstImageUrl) { isSuccess in
                if !isSuccess {
                    print("이미지 세개 로드 실패")
                    firstImageView.image = nil
                }
            }
            firstImageView.layer.cornerRadius = 8
        }
        DispatchQueue.main.async {
            secondImageView.kf.setImageWithAuthHeaders(with: secondImageUrl) { isSuccess in
                if !isSuccess {
                    secondImageView.image = nil
                }
            }
            secondImageView.layer.cornerRadius = 8
        }
        DispatchQueue.main.async {
            thirdImageView.kf.setImageWithAuthHeaders(with: thridImageUrl) { isSuccess in
                if !isSuccess {
                    thirdImageView.image = nil
                }
            }
            thirdImageView.layer.cornerRadius = 8
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 6
            secondImageView.layer.cornerRadius = 6
            thirdImageView.layer.cornerRadius = 6
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
            thirdImageView.clipsToBounds = true
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubviews([profileImageView, userNicknameButton, createdAtLabel, contentLabel, imageStackView, likeButton, commentInfoView])
    }
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.size.equalTo(36)
        }
        
        userNicknameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.height.equalTo(20)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(userNicknameButton.snp.trailing).offset(6)
            make.centerY.equalTo(userNicknameButton)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(16)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameButton.snp.bottom).offset(10)
            make.leading.equalTo(userNicknameButton)
            make.trailing.equalToSuperview().inset(16)
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(20)
            make.leading.equalTo(userNicknameButton)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(12)
            make.leading.equalTo(userNicknameButton)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }
        
        commentInfoView.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing).offset(12)
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
        layer.masksToBounds = false
        layer.shadowColor =  Color.gray.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 12
        
        contentView.backgroundColor = Color.white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        profileImageView.image = Image.emptyProfileImage
        profileImageView.contentMode = .scaleAspectFill
        
        var nicknameConfig = UIButton.Configuration.filled()
        
        nicknameConfig.baseForegroundColor = Color.black
        nicknameConfig.baseBackgroundColor = Color.white
        nicknameConfig.titleAlignment = .leading
        nicknameConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        userNicknameButton.configuration = nicknameConfig
        
        contentLabel.design(font: .pretendard(size: 16, weight: .regular),numberOfLines: 0)
        contentLabel.lineBreakMode = .byCharWrapping
        
        imageStackView.design(axis: .horizontal, spacing: 5)
        imageStackView.layer.cornerRadius = 12
        
        var likeConfig = UIButton.Configuration.filled()
        likeConfig.image = Image.heart.resized(to: CGSize(width: 20, height: 20))
        likeConfig.title = "\(0)"
        likeConfig.imagePadding = 4
        likeConfig.baseBackgroundColor = Color.white
        likeConfig.baseForegroundColor = Color.black
        likeConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        likeButton.configuration = likeConfig
    }
}
