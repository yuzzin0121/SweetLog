//
//  CreatePostView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit
import RxSwift

final class CreatePostView: BaseView {
    let placeInfoView = PlaceInfoView() // 주소 정보 뷰
    
    private let selectCategoryLabel = UILabel() // 카테고리
    var categoryButton = MenuButton(title: FilterItem.allCases[0].title)    // 선택버튼
    
    let priceTextField = UITextField()
    let priceLabel = UILabel()
    
    let selectSugarContentLabel = UILabel() // 당도
    let starStackView = UIStackView()  // 당도 선택버튼 스택뷰
    
    let textView = UITextView() // 후기 작성 텍스트뷰
    let tagTextField = UITextField()
    lazy var tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createTagLayout())
    
    var buttonList: [StarButton] = []
    let addPhotoImageView = AddPhotoImageView(frame: .zero)
    let photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let createButton = UIButton()
    
    lazy var selectedCategorySubject = BehaviorSubject(value: categoryButton.configuration?.title ?? "")
    
    func setCreateButtonTitle(cuMode: CUMode) {
        createButton.configuration?.title = cuMode == .create ? "후기 공유" : "후기 수정"
    }
    
    func setCategoryName(title: String) {
        categoryButton.configuration?.title = title
    }
    
    func setReviewText(_ text: String) {
        textView.text = text
        textView.textColor = Color.black
    }
    
    func setTagTextFieldEmpty() {
        tagTextField.text = ""
    }
    
    func setCreateButtonStatus(_ isValid: Bool) {
        print("색깔 변경\(isValid ? "갈색" : "회색")")
        createButton.configuration?.baseBackgroundColor = isValid ? Color.brown : Color.gray
        createButton.isEnabled = isValid
    }
    
    override func configureHierarchy() {
        addSubviews([placeInfoView, selectCategoryLabel, categoryButton, selectSugarContentLabel, starStackView, priceTextField, priceLabel, textView, tagTextField, tagCollectionView, addPhotoImageView, photoCollectionView])
    }
    override func configureLayout() {
        placeInfoView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
        }
        selectCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(placeInfoView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalTo(categoryButton.snp.leading).offset(-12)
            make.height.equalTo(18)
        }
        categoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectCategoryLabel)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(18)
            categoryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        }
        
        selectSugarContentLabel.snp.makeConstraints { make in
            make.top.equalTo(selectCategoryLabel.snp.bottom).offset(30)
            make.leading.equalTo(selectCategoryLabel)
            make.height.equalTo(18)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.centerY.equalTo(selectSugarContentLabel)
//            make.leading.equalTo(selectSugarContentLabel.snp.trailing).offset(12)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-8)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.centerY.equalTo(priceTextField)
        }
        
        starStackView.snp.makeConstraints { make in
            make.centerY.equalTo(selectSugarContentLabel)
            make.leading.equalTo(selectSugarContentLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(selectSugarContentLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        tagTextField.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(textView)
            make.height.equalTo(30)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagTextField.snp.bottom).offset(8)
            make.leading.equalTo(tagTextField)
            make.trailing.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.greaterThanOrEqualTo(addPhotoImageView.snp.top).offset(-20)
        }
        
        addPhotoImageView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(30)
            make.size.equalTo(100)
        }
        
        photoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(addPhotoImageView)
            make.leading.equalTo(addPhotoImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(addPhotoImageView)
        }
    }
    override func configureView() {
        super.configureView()
        selectCategoryLabel.design(text: "카테고리", font: .pretendard(size: 18, weight: .semiBold))
        selectSugarContentLabel.design(text: "평점", font: .pretendard(size: 18, weight: .semiBold))
        priceLabel.design(text: "원", font: .pretendard(size: 18, weight: .semiBold))
        configureCategoryMenu()
        
        starStackView.design(axis: .horizontal, spacing: 8)
        setStarButton()
        
        textView.layer.cornerRadius = 12
        textView.clipsToBounds = true
        textView.text = "후기를 작성해주세요"
        textView.font = .pretendard(size: 17, weight: .regular)
        textView.textColor = Color.gray
        
        photoCollectionView.showsHorizontalScrollIndicator = false
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = Color.gray
        config.baseForegroundColor = Color.white
        config.title = "후기 공유"
        config.cornerStyle = .capsule
        createButton.configuration = config
        
        priceTextField.backgroundColor = .clear
        priceTextField.placeholder = "3000"
        priceTextField.font = .pretendard(size: 20, weight: .semiBold)
        priceTextField.textColor = Color.black
        priceTextField.attributedPlaceholder = NSAttributedString(string: "3000", attributes: [.font: UIFont(name: "Pretendard-Light", size: 20)!])
        priceTextField.textAlignment = .right
        priceTextField.isHidden = true
        priceLabel.isHidden = true
        
    
        
        tagTextField.backgroundColor = Color.white
        tagTextField.placeholder = "태그를 추가해보세요... (최대 10자)"
        tagTextField.font = .pretendard(size: 15, weight: .light)
        tagTextField.textColor = Color.brown
        tagTextField.attributedPlaceholder = NSAttributedString(string: "태그를 추가해보세요... (1~10 글자)", attributes: [.font: UIFont(name: "Pretendard-Light", size: 15)!])
        
        tagCollectionView.backgroundColor = Color.white
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: TagCollectionViewCell.identifier)
        tagCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setStarButton() {
        for index in 1...5 {
            let button = StarButton()
            button.tag = index
            button.snp.makeConstraints { make in
                make.size.equalTo(36)
            }
            buttonList.append(button)
            starStackView.addArrangedSubview(button)
            button.tintColor = Color.darkBrown
        }
    }
    
    private func changeVisible(isPrice: Bool) {
        priceTextField.isHidden = !isPrice
        priceLabel.isHidden = !isPrice
        starStackView.isHidden = isPrice
        selectSugarContentLabel.text = isPrice ? "가격" : "평점"
    }
    
    private func configureCategoryMenu() {
        categoryButton.showsMenuAsPrimaryAction = true
        let actions = FilterItem.allCases.map { filterItem in
            UIAction(title: filterItem.title) { [weak self] _ in
                guard let self else { return }
                let title = filterItem.title
                categoryButton.configuration?.title = title
                self.selectedCategorySubject.onNext(title)
                if filterItem == .sale {
                    changeVisible(isPrice: true)
                } else {
                    changeVisible(isPrice: false)
                }
            }
        }
        
        categoryButton.menu = UIMenu(title: "카테고리 선택", children: actions)
    }
    
    func selectStarButton(_ tag: Int) {
        print(#function, index)
        for starIndex in 0..<buttonList.count {
            if starIndex < tag {
                buttonList[starIndex].tintColor = Color.darkBrown
            } else if starIndex >= tag {
                buttonList[starIndex].tintColor = Color.sugarBrown
            }
        }
    }
}

extension CreatePostView {
    private func createTagLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .absolute(24)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(50),
            heightDimension: .absolute(24)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        layout.configuration = config
        return layout
    }
}
