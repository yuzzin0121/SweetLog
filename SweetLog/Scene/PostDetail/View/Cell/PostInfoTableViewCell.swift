//
//  PostInfoTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostInfoTableViewCell: BaseTableViewCell {
    private let placeStackView = UIStackView()
    private let markImageView = UIImageView()
    private let placeNameLabel = UILabel()
    
    let imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = UIPageControl()
    
    private let userStackView = UIStackView()
    private let profileImageView = UIImageView()
    private let userNicknameLabel = UILabel()
    private let reviewLabel = UILabel()

    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(fetchPostItem: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: contentView.frame.width, height: 300)
        layout.scrollDirection = .horizontal
        imageCollectionView.collectionViewLayout = layout
    }
    
    func configureCell(fetchPostItem: FetchPostItem?) {
        guard let fetchPostItem else { return }
        placeNameLabel.text = fetchPostItem.placeName
        userNicknameLabel.text = fetchPostItem.creator.nickname
        reviewLabel.text = fetchPostItem.review
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        DispatchQueue.main.async {
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
            self.profileImageView.clipsToBounds = true
        }
    }
    
    override func configureHierarchy() {
        addSubviews([placeStackView, imageCollectionView, pageControl, userStackView, reviewLabel])
        [markImageView, placeNameLabel].forEach {
            placeStackView.addArrangedSubview($0)
        }
        [profileImageView, userNicknameLabel].forEach {
            userStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        placeStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(14)
        }
        markImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(placeStackView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.top).offset(8)
            make.trailing.equalTo(imageCollectionView.snp.trailing).offset(-12)
            make.height.equalTo(14)
        }
        userStackView.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(14)
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
    override func configureView() {
        placeStackView.design(axis: .horizontal, spacing: 12)
        markImageView.image = Image.markFill
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = Color.backgroundGray.withAlphaComponent(0.7)
        
        imageCollectionView.backgroundColor = .systemGray6
        imageCollectionView.isPagingEnabled = true
        imageCollectionView.delegate = self
        imageCollectionView.register(PostImageCollectionViewCell.self, forCellWithReuseIdentifier: PostImageCollectionViewCell.identifier)
        
        userStackView.design(axis: .horizontal, spacing: 12)
        profileImageView.image = Image.emptyProfileImage
    }
}


extension PostInfoTableViewCell: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("오잉")
        let page = Int(targetContentOffset.pointee.x / contentView.frame.width)
        pageControl.currentPage = page
    }
}
