//
//  HomeView.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import UIKit
import SnapKit
import RxSwift

final class HomeView: BaseView {
    let titleLabel = UILabel()
    
    let addPostButton = UIButton()
    let refreshControl = UIRefreshControl()
    
    lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCategoryLayout())
    lazy var postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createPostLayout())
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    override func configureHierarchy() {
        addSubviews([titleLabel, filterCollectionView, postCollectionView, addPostButton])
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(4)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        addPostButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
    }
    override func configureView() {
        super.configureView()
        backgroundColor = Color.backgroundGray
        
        filterCollectionView.backgroundColor = Color.backgroundGray
        filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        
        postCollectionView.backgroundColor = Color.backgroundGray
        postCollectionView.alwaysBounceVertical = true
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

        
//        let plus = Image.plusCircleFill.withTintColor(Color.brown, renderingMode: .alwaysOriginal)
//        addPostButton.setImage(plus, for: .normal)
//        
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 45)
//        addPostButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
//        addPostButton.tintColor = .white
        
        var addConfig = UIButton.Configuration.filled()
        addConfig.image = Image.add
        addConfig.cornerStyle = .capsule
        addConfig.baseBackgroundColor = Color.brown
        addConfig.baseForegroundColor = Color.white
        addPostButton.configuration = addConfig
        
        titleLabel.text = "달콤로그"
        titleLabel.font = .pretendard(size: 30, weight: .bold)
        
        postCollectionView.refreshControl = refreshControl
        refreshControl.backgroundColor = .clear
    }
}

extension HomeView {
    private func createCategoryLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(90),
            heightDimension: .absolute(38)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
    
    private func createPostLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.backgroundColor = Color.backgroundGray

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20)
            section.interGroupSpacing = 18
    

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
