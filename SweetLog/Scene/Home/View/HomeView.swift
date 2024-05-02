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
    let searchTextField = UISearchTextField()
    
    let addPostButton = UIButton()
    let disposeBag = DisposeBag()
    
    lazy var filterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createCategoryLayout())
    lazy var postCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createPostLayout())
    
    override func configureHierarchy() {
        addSubviews([searchTextField, filterCollectionView, postCollectionView, addPostButton])
    }
    override func configureLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        postCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom).offset(12)
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
        searchTextField.layer.cornerRadius = 24
        searchTextField.clipsToBounds = true
        searchTextField.placeholder = "해시태그를 검색해보세요"
        searchTextField.backgroundColor = Color.gray1
        
        filterCollectionView.backgroundColor = Color.backgroundGray
        filterCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        filterCollectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.identifier)
        
        postCollectionView.backgroundColor = Color.backgroundGray
        postCollectionView.alwaysBounceVertical = true
//        postCollectionView.contentInset = UIEdgeInsets(top: 9, left: 20, bottom: 0, right: 20)
        postCollectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

        
        let plus = Image.plusCircleFill.withTintColor(Color.brown, renderingMode: .alwaysOriginal)
        addPostButton.setImage(plus, for: .normal)
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 45)
        addPostButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        addPostButton.tintColor = .white
        
        titleLabel.text = "달콤로그"
        titleLabel.font = .pretendard(size: 26, weight: .extraBold)
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
    
//    private func createPostLayout() -> UICollectionViewLayout {
//        let itemWidth = UIScreen.main.bounds.width - 40
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(280))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .estimated(280))
//        
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(8)
//        
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 18
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        
//        let config = UICollectionViewCompositionalLayoutConfiguration()
//        config.scrollDirection = .vertical
//        
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        layout.configuration = config
//        return layout
//    
//    }
    private func createPostLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
//            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
