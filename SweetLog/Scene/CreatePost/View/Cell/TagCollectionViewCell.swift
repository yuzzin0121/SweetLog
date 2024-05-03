//
//  TagCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 5/3/24.
//

import UIKit
import RxSwift

final class TagCollectionViewCell: BaseCollectionViewCell {
    private let tagStackView = UIStackView()
    private let tagLabel = UILabel()
    let removeButton = UIButton()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    func configureCell(tagText: String) {
        print(tagText)
        tagLabel.text = tagText
        if removeButton.tag == 0 {
            removeButton.isHidden = true
        } else {
            removeButton.isHidden = false
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(tagStackView)
        [tagLabel, removeButton].forEach {
            tagStackView.addArrangedSubview($0)
        }
    }
    override func configureLayout() {
        tagStackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(8)
        }
//        tagLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(8)
//            make.centerY.equalToSuperview()
//            make.height.equalTo(16)
//        }
        
        removeButton.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.leading.equalTo(tagLabel.snp.trailing).offset(6)
//            make.trailing.equalToSuperview().offset(-6)
            make.size.equalTo(14)
        }
    }
    override func configureView() {
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.backgroundColor = Color.sugarBrown
        
        tagStackView.design(axis: .horizontal, alignment: .center,spacing: 4)
        
        tagLabel.design(textColor: Color.brown, font: .pretendard(size: 14, weight: .medium))
        removeButton.setImage(Image.x, for: .normal)
    }
}
