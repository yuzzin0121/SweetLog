//
//  CreatePostView.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit
import RxSwift

final class CreatePostView: BaseView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let placeInfoView = PlaceInfoView() // 주소 정보 뷰
    
    let selectCategoryLabel = UILabel() // 카테고리
    var categoryButton = MenuButton(title: FilterItem.allCases[0].title)    // 선택버튼
    
    let selectSugarContentLabel = UILabel() // 당도
    let sugarStackView = UIStackView()  // 당도 선택버튼 스택뷰
    var buttonList: [UIButton] = []
    
    lazy var selectedCategorySubject = BehaviorSubject(value: categoryButton.configuration?.title ?? "")
    
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([placeInfoView, selectCategoryLabel, categoryButton, selectSugarContentLabel, sugarStackView])
    }
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView)
            make.verticalEdges.equalTo(scrollView)
        }
        placeInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
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
            make.top.equalTo(selectCategoryLabel.snp.bottom).offset(50)
            make.leading.equalTo(selectCategoryLabel)
            make.height.equalTo(18)
            make.bottom.greaterThanOrEqualToSuperview().offset(-12)
        }
        
        sugarStackView.snp.makeConstraints { make in
            make.centerY.equalTo(selectSugarContentLabel)
            make.leading.greaterThanOrEqualTo(selectSugarContentLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    override func configureView() {
        super.configureView()
        contentView.isUserInteractionEnabled = true
        
        selectCategoryLabel.design(text: "카테고리", font: .pretendard(size: 18, weight: .semiBold))
        selectSugarContentLabel.design(text: "당도", font: .pretendard(size: 18, weight: .semiBold))
        
        configureCategoryMenu()
        
        sugarStackView.design(axis: .horizontal, spacing: 20)
        setSugarButton()
    }
    
    private func setSugarButton() {
        for index in 1...5 {
            let button = SugarButton()
            button.tag = index
            button.snp.makeConstraints { make in
                make.size.equalTo(34)
            }
            buttonList.append(button)
            sugarStackView.addArrangedSubview(button)
        }
        buttonList[0].configuration?.baseBackgroundColor = Color.brown
    }
    
    private func configureCategoryMenu() {
        categoryButton.showsMenuAsPrimaryAction = true
        let actions = FilterItem.allCases.map { filterItem in
            UIAction(title: filterItem.title) { [weak self] _ in
                guard let self else { return }
                let title = filterItem.title
                categoryButton.configuration?.title = title
                self.selectedCategorySubject.onNext(title)
            }
        }
        
        categoryButton.menu = UIMenu(title: "카테고리 선택", children: actions)
    }
    
    func selectSugarButton(_ index: Int) {
        for button in buttonList {
            button.configuration?.baseBackgroundColor = button.tag == index ? Color.brown : Color.sugarBrown
        }
    }
}
