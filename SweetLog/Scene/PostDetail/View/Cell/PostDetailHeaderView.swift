//
//  PostDetailHeaderView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostDetailHeaderView: UITableViewHeaderFooterView, ViewProtocol {
    let placeButton = UIButton()
    private let sugarContentLabel = UILabel()
    private let sugarStackView = UIStackView()
    var sugarViewList: [SugarView] = []
    
    private var imageScrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private let profileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let createdAtLabel = UILabel()
    
    let likeButton = UIButton()
    private let reviewLabel = UILabel()
    
    private let commentStackView = UIStackView()
    private let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageScrollView = UIScrollView()
        configureHeader(fetchPostItem: nil)
    }
    
    func configureHeader(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        placeButton.configuration?.title = fetchPostItem.placeName
        userNicknameLabel.text = fetchPostItem.creator.nickname
        createdAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(fetchPostItem.createdAt)
        reviewLabel.text = fetchPostItem.review
        pageControl.numberOfPages = fetchPostItem.files.count
        setImages(fileList: fetchPostItem.files)
        setSugar(sugarValue: fetchPostItem.sugar)
    }
    
    private func setSugar(sugarValue: String?) {
        if sugarViewList.isEmpty { return }
        guard let sugarString = sugarValue, let sugar = Int(sugarString) else { return }
        print("당도 - \(sugar)")
        for index in 0..<sugar {
            sugarViewList[index].backgroundColor = Color.brown
        }
    }
    
    // 이미지 데이터 스크롤뷰에 적용
    private func setImages(fileList: [String]) {
        pageControl.numberOfPages = fileList.count
        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(fileList.count), height: 300)
        for index in 0..<fileList.count {
            let imageView = PhotoImageView(frame: .zero)
            imageScrollView.addSubview(imageView)
            
            imageView.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index),
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: 300)
            DispatchQueue.main.async {
                imageView.kf.setImageWithAuthHeaders(with: fileList[index]) { isSuccess in
                    if !isSuccess { // 실패할 경우
                        imageView.image = nil
                    }
                }
            }
            
            print(imageView.frame.minX)
        }
    }
    
    private func setSugarView() {
        sugarStackView.design(axis: .horizontal, spacing: 8)
        for index in 1...5 {
            let sugarView = SugarView()
            sugarView.tag = index
            sugarViewList.append(sugarView)
            sugarStackView.addArrangedSubview(sugarView)
            
            DispatchQueue.main.async {
                sugarView.layer.cornerRadius = sugarView.frame.height / 2
            }
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
        addSubviews([placeButton, sugarContentLabel, sugarStackView, imageScrollView, pageControl, profileImageView, userNicknameLabel, createdAtLabel, likeButton, reviewLabel, commentStackView])
        
        [commentImageView, commentCountLabel].forEach {
            commentStackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        placeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(15)
        }
        sugarContentLabel.snp.makeConstraints { make in
            make.top.equalTo(placeButton.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(15)
        }
        
        sugarStackView.snp.makeConstraints { make in
            make.centerY.equalTo(sugarContentLabel)
            make.leading.equalTo(sugarContentLabel.snp.trailing).offset(8)
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(sugarContentLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
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
        commentStackView.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(24)
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
        
        sugarContentLabel.design(text: "당도", font: .pretendard(size: 17, weight: .medium))
        setSugarView()
        
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
        likeConfig.background.strokeWidth = 2
        placeConfig.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        likeButton.configuration = likeConfig
        
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
