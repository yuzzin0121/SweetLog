//
//  SearchPlaceView.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit

final class SelectPlaceView: BaseView {
    let searchBar = SearchBar(placeholder: "리뷰를 작성할 장소를 검색하세요")
    let placeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureHierarchy() {
        addSubviews([searchBar, placeCollectionView])
    }
    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        placeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        super.configureView()
        
        searchBar.searchTextField.backgroundColor = nil
        searchBar.layer.cornerRadius = 24
        searchBar.clipsToBounds = true
        searchBar.placeholder = "리뷰를 작성할 장소를 검색하세요"
        searchBar.backgroundColor = Color.gray1
        
        placeCollectionView.backgroundColor = Color.white
        placeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        placeCollectionView.register(PlaceCollectionViewCell.self, forCellWithReuseIdentifier: PlaceCollectionViewCell.identifier)
    }
}
