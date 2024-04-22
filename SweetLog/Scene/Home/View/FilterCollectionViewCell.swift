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
    
    func configureCell(item: FilterItem) {
        var config = filterButton.configuration
        config?.title = item.title
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
