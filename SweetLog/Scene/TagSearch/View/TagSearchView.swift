//
//  TagSearchView.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class TagSearchView: BaseView {
    let tagSearchBar = SearchBar(placeholder: "해시태그로 검색해보세요")
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func configureHierarchy() {
        addSubviews([tagSearchBar, tagCollectionView])
    }
    override func configureLayout() {
        tagSearchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(45)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagSearchBar.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        super.configureView()
        
        backgroundColor = Color.backgroundGray
        
        
    }
}
