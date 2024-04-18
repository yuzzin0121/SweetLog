//
//  HomeView.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import UIKit
import SnapKit

final class HomeView: BaseView {
    let titleLabel = UILabel()
    let searchTextField = UISearchTextField()
    let addPostButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
   
//    func createCollectionViewLayout() -> UICollectionViewLayout {
//        let collectionViewLayout = UICollectionViewCompositionalLayout(section: createLayout())
//    }
//    
//    func createLayout() -> NSCollectionLayoutSection {
//        
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(200))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 12
//        
//        return section
//    }
    
    override func configureHierarchy() {
        addSubviews([searchTextField, collectionView, addPostButton])
    }
    override func configureLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        addPostButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.size.equalTo(50)
        }
    }
    override func configureView() {
        searchTextField.layer.cornerRadius = 24
        searchTextField.clipsToBounds = true
        
        collectionView.backgroundColor = Color.backgroundGray
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)

        
        let plus = Image.plusCircleFill.withTintColor(Color.brown, renderingMode: .alwaysOriginal)
        addPostButton.setImage(plus, for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 45)
        addPostButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        
        titleLabel.text = "달콤로그"
        titleLabel.font = .pretendard(size: 26, weight: .extraBold)
    }
}
