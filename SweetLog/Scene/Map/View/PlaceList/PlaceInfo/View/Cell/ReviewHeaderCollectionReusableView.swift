//
//  ReviewHeaderCollectionReusableView.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import UIKit
import LinkPresentation

class ReviewHeaderCollectionReusableView: UICollectionReusableView, ViewProtocol {
    let placeNameLabel = UILabel()
    let categoryLabel = UILabel()
    let callButton = UIButton()
    let placeInfoView = PlaceInfoView()
    let linkView = LPLinkView()
    let divisionLineView = UIView()
    
    let reviewLabel = UILabel()
    let reviewCountLabel = UILabel()
    
    func setReviewCount(_ count: Int) {
        reviewCountLabel.text = "\(NumberFomatterManager.shared.formattedNumber(count))"
    }
    
    func setPlaceItem(_ placeItem: PlaceItem, meta: LPLinkMetadata) {
        placeNameLabel.text = placeItem.placeName
        categoryLabel.text = String.getLastCategory(category: placeItem.categoryName)
        placeInfoView.placeNameLabel.isHidden = true
        placeInfoView.addressLabel.text = placeItem.address
        linkView.metadata = meta
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        addSubviews([placeNameLabel, categoryLabel, callButton,
                     placeInfoView, linkView, divisionLineView,
                     reviewLabel, reviewCountLabel])
    }
    func configureLayout() {
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(placeNameLabel.snp.trailing).offset(6)
            make.bottom.equalTo(placeNameLabel.snp.bottom)
        }
        callButton.snp.makeConstraints { make in
            make.bottom.equalTo(categoryLabel)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(20)
        }
        
        placeInfoView.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        linkView.snp.makeConstraints { make in
            make.top.equalTo(placeInfoView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(placeInfoView)
            make.height.equalTo(150)
        }
        divisionLineView.snp.makeConstraints { make in
            make.top.equalTo(linkView.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(6)
        }
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(divisionLineView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
        }
        
        reviewCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(reviewLabel)
            make.leading.equalTo(reviewLabel.snp.trailing).offset(4)
            make.bottom.equalToSuperview()
        }
    }
    func configureView() {
        placeNameLabel.design(font: .pretendard(size: 24, weight: .bold))
        categoryLabel.design(textColor: Color.gray, font: .pretendard(size: 12, weight: .light))
        callButton.setImage(Image.call, for: .normal)
        placeInfoView.backgroundColor = Color.gray2
        linkView.layer.cornerRadius = 12
        linkView.clipsToBounds = true
        divisionLineView.backgroundColor = Color.gray2
        
        reviewLabel.design(text: "후기", font: .pretendard(size: 16, weight: .semiBold))
        reviewCountLabel.design(textColor: Color.buttonGray, font: .pretendard(size: 15, weight: .extraBold))

    }
    
}
