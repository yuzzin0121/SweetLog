//
//  ChatRoomView.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import UIKit

final class ChatRoomView: BaseView {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createChatLayout())
    let bottomBackgroundView = UIView()
    let inputTextView = UITextView()
    let sendButton = UIButton()
    
    override func configureHierarchy() {
        [collectionView, bottomBackgroundView].forEach {
            addSubview($0)
        }
        [inputTextView, sendButton].forEach {
            bottomBackgroundView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(inputTextView.snp.top)
        }
        
        bottomBackgroundView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        inputTextView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.leading.equalTo(12)
        }
    }
    
    override func configureView() {
        super.configureView()
        collectionView.backgroundColor = Color.white
        
        inputTextView.backgroundColor = Color.sugarBrown
        inputTextView.layer.cornerRadius = inputTextView.frame.height / 2
    }
    
    private func createChatLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.backgroundColor = Color.white

            let section = NSCollectionLayoutSection.list(
                using: config,
                layoutEnvironment: layoutEnvironment
            )
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            section.interGroupSpacing = 18
    

            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
