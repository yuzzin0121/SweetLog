//
//  TagPostCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

class TagPostCollectionViewCell: BaseCollectionViewCell {
    private let thumbnailImageView = PhotoImageView(frame: .zero)
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func configureCell(postItem: FetchPostItem?) {
        guard let postItem else { return }
        guard let imageUrl = postItem.files.first else { return }
        thumbnailImageView.kf.setImageWithAuthHeaders(with: imageUrl) { [weak self] isSuccess in
            guard let self else { return }
            if !isSuccess {
                thumbnailImageView.image = Image.addPhoto
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(thumbnailImageView)
    }
    override func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        thumbnailImageView.layer.cornerRadius = 4
        thumbnailImageView.clipsToBounds = true
    }
}
