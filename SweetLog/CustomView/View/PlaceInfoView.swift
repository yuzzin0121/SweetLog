//
//  PlaceInfoView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

final class PlaceInfoView: BaseView {
    let markImageView = UIImageView()
    let infoStackView = UIStackView()
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    
    override func configureHierarchy() {
        addSubviews([markImageView, infoStackView])
        [placeNameLabel, addressLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        markImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(24)
        }
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(markImageView)
            make.leading.equalTo(markImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    override func configureView() {
        layer.borderColor = Color.borderGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
        clipsToBounds = true
        
        markImageView.image = Image.markFill
        markImageView.tintColor = Color.gray
        infoStackView.design()
        
        placeNameLabel.design(textColor: Color.black, font: .pretendard(size: 16, weight: .medium))
        addressLabel.design(textColor: Color.gray, font: .pretendard(size: 14, weight: .regular))
    }
}
