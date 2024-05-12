//
//  PostDetailHeaderView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit
import RxSwift

final class PostDetailHeaderView: UITableViewHeaderFooterView, ViewProtocol {
    let placeButton = UIButton()
    let priceLabel = UILabel()
    let buyingButton = UIButton()
    private let starStackView = UIStackView()
    var starImageViewList: [StarImageView] = []
    
    private var imageScrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    let profileImageView = UIImageView()
    let userNicknameLabel = UILabel()
    private let createdAtLabel = UILabel()
    
    let likeButton = UIButton()
    private let reviewLabel = UILabel()
    private let hashtagLabel = UILabel()
    
    private let commentStackView = UIStackView()
    private let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    
    var disposeBag = DisposeBag()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        imageScrollView = UIScrollView()
        configureHeader(fetchPostItem: nil)
    }
    
    func configureHeader(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        placeButton.configuration?.title = fetchPostItem.placeName
        priceLabel.text = fetchPostItem.price
        userNicknameLabel.text = fetchPostItem.creator.nickname
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(fetchPostItem.createdAt)
        reviewLabel.text = String.unTaggedText(text: fetchPostItem.review)
        reviewLabel.addCharacterSpacing()
        
        if !fetchPostItem.hashTags.isEmpty {
            hashtagLabel.text = String.getListToString(array: fetchPostItem.hashTags)
            hashtagLabel.isHidden = false
        } else {
            hashtagLabel.isHidden = true
        }
        
        let newSize = reviewLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height: CGFloat.greatestFiniteMagnitude))
        reviewLabel.snp.makeConstraints { make in
            make.height.equalTo(newSize.height)
        }
        
        pageControl.numberOfPages = fetchPostItem.files.count
        setImages(fileList: fetchPostItem.files)
        setStar(starValue: fetchPostItem.star)
        commentCountLabel.text = "\(fetchPostItem.comments.count)개"
        commentCountLabel.addCharacterSpacing()
        likeButton.configuration?.title = "\(fetchPostItem.likes.count)"
        
        setProfileImage(profileUrl: fetchPostItem.creator.profileImage)
        setLike(likes: fetchPostItem.likes)
        
        setPriceVisible(productId: fetchPostItem.productId)
    }
    
    private func setPriceVisible(productId: String?) {
        guard let productId else { return }
        let isPrice = productId == FilterItem.sale.title
        priceLabel.isHidden = !isPrice
        buyingButton.isHidden = !isPrice
        starStackView.isHidden = isPrice
    }
    
    private func setLike(likes: [String]) {
        let ifILike = likes.contains(UserDefaultManager.shared.userId)
        likeButton.isSelected = ifILike
        likeButton.configuration?.baseForegroundColor = ifILike ? Color.brown2 : Color.gray
        likeButton.configuration?.background.strokeColor = ifILike ? Color.brown2 : Color.borderGray
        likeButton.configuration?.image = ifILike ? Image.heartFill.resized(to: CGSize(width: 20, height: 20)) : Image.heart.resized(to: CGSize(width: 20, height: 20))
    }
    
    private func setProfileImage(profileUrl: String?) {
        guard let profileUrl else { return }
        profileImageView.kf.setImageWithAuthHeaders(with: profileUrl) { isSuccess in
            if !isSuccess {
                print("프로필 사진 로드 에러")
            }
        }
    }
    
    private func setStar(starValue: String?) {
        if starImageViewList.isEmpty { return }
        guard let starString = starValue, let star = Int(starString) else { return }
        for index in 0..<star {
            starImageViewList[index].tintColor = Color.darkBrown
        }
    }
    
    // 이미지 데이터 스크롤뷰에 적용
    private func setImages(fileList: [String]) {
        pageControl.numberOfPages = fileList.count
        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(fileList.count), height: 350)
        
        for index in 0..<fileList.count {
            let imageView = PhotoImageView(frame: .zero)
            imageScrollView.addSubview(imageView)
    
            DispatchQueue.main.async {
                imageView.kf.setImageWithAuthHeaders(with: fileList[index]) { isSuccess in
                    if !isSuccess { // 실패할 경우
                        imageView.image = nil
                    }
                }
            }
            
            imageView.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index),
                                                         y: 0,
                                                         width: UIScreen.main.bounds.width,
                                                         height: 350)
        }
    }
    
    private func setStarView() {
        starStackView.design(axis: .horizontal, spacing: 8)
        for index in 1...5 {
            let starImageView = StarImageView(frame: .zero)
            starImageView.tag = index
            starImageViewList.append(starImageView)
            starStackView.addArrangedSubview(starImageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    func configureHierarchy() {
        addSubviews([placeButton, starStackView, priceLabel, buyingButton,
                     imageScrollView, pageControl,
                     profileImageView, userNicknameLabel, createdAtLabel, likeButton,
                     reviewLabel, hashtagLabel,
                     commentStackView])
        
        [commentImageView, commentCountLabel].forEach {
            commentStackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        placeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
        }
        starStackView.snp.makeConstraints { make in
            make.top.equalTo(placeButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(18)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(placeButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(20)
        }
        buyingButton.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.trailing.equalToSuperview().inset(18)
        }
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(starStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(350)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imageScrollView.snp.bottom).offset(-6)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(18)
            make.size.equalTo(36)
        }
        userNicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            
        }
        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(userNicknameLabel.snp.bottom).offset(4)
            make.leading.equalTo(userNicknameLabel)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(18)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(18)
        }
        hashtagLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(reviewLabel)
        }
        commentStackView.snp.makeConstraints { make in
            make.top.equalTo(hashtagLabel.snp.bottom).offset(24)
            make.leading.equalTo(reviewLabel)
            make.bottom.equalToSuperview()
        }
        commentImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
  
    }
    
    func configureView() {
        var placeConfig = UIButton.Configuration.filled()
        placeConfig.baseBackgroundColor = Color.white
        placeConfig.image = Image.markFill
        placeConfig.title = "장소 이름"
        placeConfig.imagePadding = 8
        placeConfig.baseForegroundColor = Color.black
        placeConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        placeButton.configuration = placeConfig
        
        setStarView()
        priceLabel.design(font: .pretendard(size: 20, weight: .semiBold))
        var buyConfig = UIButton.Configuration.filled()
        buyConfig.title = "구매하기"
        buyConfig.cornerStyle = .capsule
        buyConfig.baseBackgroundColor = Color.orange
        buyConfig.baseForegroundColor = Color.white
        buyingButton.configuration = buyConfig
        
        imageScrollView.isPagingEnabled = true
        imageScrollView.backgroundColor = Color.white
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.white.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = Color.white
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false

        profileImageView.image = Image.emptyProfileImage
        userNicknameLabel.design(font: .pretendard(size: 15, weight: .medium))
        createdAtLabel.design(text: "날짜", textColor: Color.gray, font: .pretendard(size: 13, weight: .light))
        
        var likeConfig = UIButton.Configuration.filled()
        likeConfig.image = Image.heart.resized(to: CGSize(width: 20, height: 20))
        likeConfig.title = "\(0)"
        likeConfig.imagePadding = 4
        likeConfig.baseBackgroundColor = Color.white
        likeConfig.baseForegroundColor = Color.gray
        likeConfig.cornerStyle = .capsule
        likeConfig.background.strokeColor = Color.borderGray
        likeConfig.background.strokeWidth = 1.5
        likeButton.configuration = likeConfig
        
        reviewLabel.design(font: .pretendard(size: 16, weight: .regular), numberOfLines: 0)
        reviewLabel.lineBreakMode = .byCharWrapping
        
        hashtagLabel.design(textColor: Color.brown, font: .pretendard(size: 14, weight: .light), numberOfLines: 0)
        hashtagLabel.isHidden = true
        
        commentStackView.design(axis: .horizontal, spacing: 8)
        commentImageView.image = Image.messages
        commentCountLabel.design(text: "\(0)개", font: .pretendard(size: 16, weight: .regular))
        
    }
}

extension PostDetailHeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
