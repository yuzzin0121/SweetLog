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
    
    func setEmptyInputTextView() {
        inputTextView.text = ""
    }

    func isTextEmpty(_ isTextEmpty: Bool) {
        sendButton.isEnabled = !isTextEmpty
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self else { return }
            sendButton.alpha = isTextEmpty ? 0 : 1
        }
    }
    
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
            make.height.equalTo(48)
        }
        
        // 높이 50-12 = 38
        inputTextView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(6)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(inputTextView.snp.bottom).offset(-2)
            make.trailing.equalTo(inputTextView.snp.trailing).offset(-2)
            make.size.equalTo(32)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        inputTextView.layer.cornerRadius = inputTextView.frame.height / 2
        inputTextView.clipsToBounds = true
    }
    
    override func configureView() {
        super.configureView()
        collectionView.backgroundColor = Color.white
        collectionView.register(UserChatCollectionViewCell.self, forCellWithReuseIdentifier: UserChatCollectionViewCell.identifier)
        collectionView.register(MyChatCollectionViewCell.self, forCellWithReuseIdentifier: MyChatCollectionViewCell.identifier)
        
        bottomBackgroundView.backgroundColor = Color.white
        inputTextView.backgroundColor = Color.sugarBrown2
        inputTextView.font = .pretendard(size: 16, weight: .regular)
        inputTextView.contentInset = UIEdgeInsets(top: 6, left: 12, bottom: 2, right: 46)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Color.orange
        config.baseForegroundColor = Color.white
        config.image = Image.chat.resized(to: CGSize(width: 20, height: 20)).withTintColor(Color.white)
        config.cornerStyle = .capsule
        sendButton.configuration = config
        sendButton.alpha = 0
    }

    
    private func createChatLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            
            var config = UICollectionLayoutListConfiguration(appearance: .plain)
            config.showsSeparators = false
            config.backgroundColor = .white

            // Item Size
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            // Group Size
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0)
            section.interGroupSpacing = 20

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
}
