//
//  UserPostCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import UIKit

class UserPostCollectionViewCell: BaseCollectionViewCell {
    let postThumbnailImageView = PostImageView(frame: .zero)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        configureCell(postItem: nil)
    }
    
    func configureCell(postItem: FetchPostItem?) {
        guard let postItem else { return }
        guard let firstImageUrl = postItem.files.first else { return }
        postThumbnailImageView.kf.setImageWithAuthHeaders(with: firstImageUrl) { isSuccess in
            if !isSuccess {
                print("포스트 이미지 로드 실패")
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(postThumbnailImageView)
    }
    override func configureLayout() {
        postThumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        postThumbnailImageView.layer.cornerRadius = 8
        postThumbnailImageView.clipsToBounds = true
    }
}
