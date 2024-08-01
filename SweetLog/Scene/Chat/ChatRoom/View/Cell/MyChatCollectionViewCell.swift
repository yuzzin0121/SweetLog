//
//  MyChatCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 7/22/24.
//

import UIKit

final class MyChatCollectionViewCell: BaseCollectionViewCell {
    private let contentBackgroundView = UIView()
    private let contentLabel = UILabel()
    private let createdAtLabel = UILabel()
    
    func configureCell(chat: Chat) {
        contentLabel.text = chat.content
        createdAtLabel.text = DateFormatterManager.shared.formattedDate(chat.createdAt)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(contentBackgroundView)
        contentView.addSubview(createdAtLabel)
        contentBackgroundView.addSubview(contentLabel)
    }
    
    override func configureLayout() {
        contentBackgroundView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.top.equalToSuperview().inset(6)
            make.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(10)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentBackgroundView.snp.bottom)
            make.trailing.equalTo(contentBackgroundView.snp.leading).offset(-4)
            make.leading.greaterThanOrEqualToSuperview().offset(60)
        }
    }
    
    override func configureView() {
        contentBackgroundView.backgroundColor = Color.backgroundGray
        contentLabel.design(font: .pretendard(size: 16, weight: .regular), numberOfLines: 0)
        createdAtLabel.design(textColor: Color.gray4, font: .pretendard(size: 12, weight: .regular))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        contentBackgroundView.layer.cornerRadius = 12
        contentBackgroundView.clipsToBounds = true
        
    }
}
