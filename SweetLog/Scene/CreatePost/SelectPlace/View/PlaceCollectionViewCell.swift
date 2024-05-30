//
//  PlaceCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit

final class PlaceCollectionViewCell: BaseCollectionViewCell {
    let locationImageView = UIImageView()
    let placeStackView = UIStackView()
    let placeLabel = UILabel()
    let addressLabel = UILabel()
    let underLineView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(nil)
    }
    
    // MARK: - setData
    func configureCell(_ placeItem: PlaceItem?) {
        guard let placeItem = placeItem else { return }
        placeLabel.text = placeItem.placeName
        addressLabel.text = placeItem.address
    }
    
    // MARK: - Configure
    override func configureHierarchy() {
        contentView.addSubviews([locationImageView, placeStackView, underLineView])
        [placeLabel, addressLabel].forEach {
            placeStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        locationImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(32)
        }
        placeStackView.snp.makeConstraints { make in
            make.leading.equalTo(locationImageView.snp.trailing).offset(14)
            make.centerY.equalTo(locationImageView)
            make.trailing.equalToSuperview().inset(12)
        }
        placeLabel.snp.makeConstraints { make in
            make.height.equalTo(18)
        }
        addressLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        underLineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        locationImageView.image = Image.markFill
        locationImageView.tintColor = Color.gray
        placeStackView.design()
        placeLabel.design(font: .pretendard(size: 16, weight: .semiBold))
        addressLabel.design(textColor: Color.gray, font: .pretendard(size: 15, weight: .regular))
        
        underLineView.backgroundColor = Color.separatorGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
