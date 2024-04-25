//
//  PostDetailHeaderView.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

class PostDetailHeaderView: UITableViewHeaderFooterView, ViewProtocol {
    
    private let placeStackView = UIStackView()
    private let markImageView = UIImageView()
    private let placeNameLabel = UILabel()
    
    let imageScrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private let userStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let reviewLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureHeader(fetchPostItem: nil)
    }
    
    func configureHeader(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        placeNameLabel.text = fetchPostItem.placeName
        userNicknameLabel.text = fetchPostItem.creator.nickname
        reviewLabel.text = fetchPostItem.review
        pageControl.numberOfPages = fetchPostItem.files.count
        setImages(fileList: fetchPostItem.files)
    }
    
    
    // 이미지 데이터 스크롤뷰에 적용
    private func setImages(fileList: [String]) {
        pageControl.numberOfPages = fileList.count
        imageScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(fileList.count), height: 300)
        for index in 0..<fileList.count {
            let imageView = PostImageView(frame: .zero)
            imageView.kf.setImageWithAuthHeaders(with: fileList[index]) { isSuccess in
                if !isSuccess { // 실패할 경우
                    imageView.image = nil
                    imageView.backgroundColor = .gray
                }
            }
            imageView.contentMode = .scaleAspectFill
            
            imageView.frame = CGRect(x: UIScreen.main.bounds.width * CGFloat(index),
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: 300)
            imageScrollView.addSubview(imageView)
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
        addSubviews([placeStackView, imageScrollView, pageControl, userStackView, reviewLabel])
        [markImageView, placeNameLabel].forEach {
            placeStackView.addArrangedSubview($0)
        }
        [profileImageView, userNicknameLabel].forEach {
            userStackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        placeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(14)
        }
        markImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        imageScrollView.snp.makeConstraints { make in
            make.top.equalTo(placeStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageScrollView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.height.equalTo(14)
        }
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(14)
        }
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(userStackView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configureView() {
        placeStackView.design(axis: .horizontal, spacing: 12)
        markImageView.image = Image.markFill
        
        imageScrollView.isPagingEnabled = true
        imageScrollView.isScrollEnabled = true
        imageScrollView.backgroundColor = .systemGray6
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.delegate = self
        
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.gray
        pageControl.currentPageIndicatorTintColor = Color.darkBrown
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
    
        userStackView.design(axis: .horizontal, spacing: 12)
        profileImageView.image = Image.emptyProfileImage
    }
}

extension PostDetailHeaderView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(round(imageScrollView.contentOffset.x / UIScreen.main.bounds.width))
    }
}
