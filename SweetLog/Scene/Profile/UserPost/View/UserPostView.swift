//
//  UserPostView.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit

final class UserPostView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func configureHierarchy() {
        addSubview(collectionView)
    }
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    override func configureView() {
        super.configureView()
        collectionView.backgroundColor = .systemGray6
    }
}
