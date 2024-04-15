//
//  SettingView.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import UIKit

final class SettingView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    override func configureView() {
        collectionView.register(SettingCollectionViewCell.self, forCellWithReuseIdentifier: SettingCollectionViewCell.identifier)
    }
}
