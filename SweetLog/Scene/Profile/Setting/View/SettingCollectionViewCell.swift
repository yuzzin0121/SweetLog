//
//  SettingCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import UIKit

final class SettingCollectionViewCell: BaseCollectionViewCell {
    private let titleLabel = UILabel()
    
    func configureCell(item: SettingItem) {
        titleLabel.text = item.title
        titleLabel.textColor = item.textColor
    }

    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    override func configureView() {
        titleLabel.font = .pretendard(size: 17, weight: .medium)
    }
}
