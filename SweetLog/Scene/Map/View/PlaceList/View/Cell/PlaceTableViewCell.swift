//
//  PlaceTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

class PlaceTableViewCell: BaseTableViewCell {
    let markImageView = UIImageView()
    let placeNameLabel = UILabel()
    let categoryLabel = UILabel()
    let addressLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(placeItem: nil)
    }
    
    func configureCell(placeItem: PlaceItem?) {
        guard let placeItem else { return }
        placeNameLabel.text = placeItem.placeName
        categoryLabel.text = placeItem.categoryName
        addressLabel.text = placeItem.address
    }
    
    override func configureHierarchy() {
        addSubviews([markImageView, placeNameLabel, categoryLabel, addressLabel])
    }
    override func configureLayout() {
        markImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(markImageView.snp.top)
            make.leading.equalTo(markImageView.snp.trailing).offset(12)
            make.height.equalTo(17)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.top).offset(3)
            make.leading.equalTo(placeNameLabel.snp.trailing).offset(8)
            make.height.equalTo(11)
        }
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            make.leading.equalTo(placeNameLabel)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(14)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
    }
    override func configureView() {
        markImageView.image = Image.markFill
        markImageView.tintColor = Color.sugarBrown
        
        placeNameLabel.design(font: .pretendard(size: 16, weight: .bold))
        categoryLabel.design(textColor: Color.gray, font: .pretendard(size: 11, weight: .light))
        addressLabel.design(font: .pretendard(size: 14, weight: .light))
    }
}
