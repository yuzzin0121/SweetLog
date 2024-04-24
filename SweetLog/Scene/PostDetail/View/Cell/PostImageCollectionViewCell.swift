//
//  PostImageCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

class PostImageCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configureCell(fileString: String) {
        imageView.kf.setImageWithAuthHeaders(with: fileString) { isSuccess in
            if !isSuccess {
                print("실패")
            }
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(imageView)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.image = Image.markFill
    }
}
