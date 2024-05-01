//
//  FilterCollectionViewCell.swift
//  SweetLog
//
//  Created by 조유진 on 4/21/24.
//

import UIKit
import RxSwift

final class FilterCollectionViewCell: BaseCollectionViewCell {
    let filterButton = FilterButton()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configureCell(item: FilterItem, selectedCategory: String) {
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.boldSystemFont(ofSize: 15)
        
        var config = filterButton.configuration
        config?.title = item.title
        config?.attributedTitle = AttributedString(item.title, attributes: titleContainer)
        filterButton.configuration = config
        
        if item.title == selectedCategory {
            setSelectStatus(true)
        } else {
            setSelectStatus(false)
        }
    }
    
    func setSelectStatus(_ isSelected: Bool) {
        guard var config = filterButton.configuration else { return }
        config.baseBackgroundColor = isSelected ? Color.brown : Color.white
        config.baseForegroundColor = isSelected ? Color.white : Color.darkBrown
        config.background.strokeColor = isSelected ? Color.darkBrown : Color.buttonStrokeGray
        filterButton.configuration = config
    }
    
    
    override func configureHierarchy() {
        contentView.addSubview(filterButton)
    }
    override func configureLayout() {
        filterButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    override func configureView() {
        
    }
}
