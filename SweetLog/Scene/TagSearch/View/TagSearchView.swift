//
//  TagSearchView.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

final class TagSearchView: BaseView {
    let titleLabel = UILabel()
    let tagSearchBar = SearchBar(placeholder: "해시태그로 검색해보세요")
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    override func configureHierarchy() {
        addSubviews([titleLabel, tagSearchBar, tagCollectionView])
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
        }
        
        tagSearchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
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
        
        backgroundColor = Color.white
        
        titleLabel.text = "검색"
        titleLabel.font = .pretendard(size: 30, weight: .bold)
        
        tagCollectionView.showsVerticalScrollIndicator = false
        tagCollectionView.register(TagPostCollectionViewCell.self,
                                   forCellWithReuseIdentifier: TagPostCollectionViewCell.identifier)
    }
}

extension TagSearchView {
    func createLayout() -> UICollectionViewLayout {
        
//        let rightMainGroup = createRightMainGroup()
//        let leftMainGroup = createLeftMainGroup()
//        
//        let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                     heightDimension: .fractionalWidth(16/9))
//        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: nestedGroupSize,
//                                                           subitems: [rightMainGroup, leftMainGroup])
//
//        let section = NSCollectionLayoutSection(group: nestedGroup)
//        let layout = UICollectionViewCompositionalLayout(section: section)
        
        // 1
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/3)))
            fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        // 2
        let mainItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let pairItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5)))
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)), subitems: [pairItem, pairItem])

        let mainWithTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(5/9)), subitems: [mainItem, trailingGroup, trailingGroup])
        
        let tripleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0)))
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2/9)), subitems: [tripleItem, tripleItem, tripleItem])
        
        let mainWithReversedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(5/9)), subitems: [trailingGroup, mainItem])
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(18/9)), subitems: [mainWithTrailingGroup, tripleGroup, mainWithReversedGroup])

        let section = NSCollectionLayoutSection(group: nestedGroup)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func createTripleGroup() -> NSCollectionLayoutGroup {
        let tripleItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                    heightDimension: .fractionalHeight(1.0))
        let tripleItem = NSCollectionLayoutItem(layoutSize: tripleItemSize)
        tripleItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        let tripleGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalWidth(2/9))
        let tripleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: tripleGroupSize, subitems: [tripleItem, tripleItem, tripleItem])
        
        return tripleGroup
    }
    
    func createMainItem() -> NSCollectionLayoutItem {
        let mainItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                  heightDimension: .fractionalHeight(1.0))
        let mainItem = NSCollectionLayoutItem(layoutSize: mainItemSize)
        mainItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return mainItem
    }
    
    func createPairItem() -> NSCollectionLayoutItem {
        let pairItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(0.5))
        let pairItem = NSCollectionLayoutItem(layoutSize: pairItemSize)
        pairItem.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        return pairItem
    }
    
    func createTrailingGroup() -> NSCollectionLayoutGroup {
        let pairItem = createPairItem()

        let trailingGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                       heightDimension: .fractionalHeight(1.0))
        let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: trailingGroupSize,
                                                             subitems: [pairItem, pairItem])
        
        return trailingGroup
    }
    
    func createRightMainGroup() -> NSCollectionLayoutGroup {
        let mainItem = createMainItem()
        let trailingGroup = createTrailingGroup()
        
        let rightMainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                               heightDimension: .fractionalWidth(5/9))
        
        let rightMainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rightMainGroupSize,
                                                                       subitems: [mainItem, trailingGroup, trailingGroup])
        return rightMainGroup
    }
    
    func createLeftMainGroup() -> NSCollectionLayoutGroup {
        let mainItem = createMainItem()
        let trailingGroup = createTrailingGroup()
        
        let leftMainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .fractionalWidth(5/9))
        let leftMainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: leftMainGroupSize,
                                                                     subitems: [trailingGroup, trailingGroup, mainItem])
        return leftMainGroup
    }
}
