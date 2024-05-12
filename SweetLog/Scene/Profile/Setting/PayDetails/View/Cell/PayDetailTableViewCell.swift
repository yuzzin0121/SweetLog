//
//  PayDetailTableViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import UIKit

class PayDetailTableViewCell: BaseTableViewCell {
    let productNameLabel = UILabel()
    let priceLabel = UILabel()
    let paidAtLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(payDetail: nil)
    }
    
    func configureCell(payDetail: PayDetail?) {
        guard let payDetail else { return }
        paidAtLabel.text = DateFormatterManager.shared.formattedUpdatedDate(payDetail.paidAt)
        productNameLabel.text = payDetail.productName
        priceLabel.text = NumberFomatterManager.shared.formattedNumber(payDetail.price) + "원"
    }
    
    override func configureHierarchy() {
        addSubviews([productNameLabel, priceLabel, paidAtLabel])
    }
    override func configureLayout() {
        paidAtLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        productNameLabel.snp.makeConstraints { make in
            make.top.equalTo(paidAtLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(productNameLabel)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    override func configureView() {
        paidAtLabel.design(textColor: Color.gray3, font: .pretendard(size: 14, weight: .regular))
        priceLabel.design(font: .pretendard(size: 18, weight: .light))
        productNameLabel.design(font: .pretendard(size: 18, weight: .semiBold))
    }
}
