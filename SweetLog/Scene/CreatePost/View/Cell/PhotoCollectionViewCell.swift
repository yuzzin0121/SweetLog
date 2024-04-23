//
//  PhotoCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

class PhotoCollectionViewCell: BaseCollectionViewCell {
    let photoImageView = PhotoImageView(frame: .zero)
//    let deleteButton = UIButton()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        configureCell(data: nil)
    }
    
    // MARK: - setData
    func configureCell(data: Data?) {
        guard let data = data else { return }
        photoImageView.image = UIImage(data: data)
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        contentView.addSubview(photoImageView)
//        contentView.addSubview(deleteButton)
    }
    
    override func configureLayout() {
        photoImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
//        deleteButton.snp.makeConstraints { make in
//            make.size.equalTo(32)
//            make.trailing.equalToSuperview().offset(12)
//            make.top.equalToSuperview().offset(-12)
//        }
    }
    
    override func configureView() {
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
//        deleteButton.setImage(ImageStyle.xCircle, for: .normal)
    }
}
