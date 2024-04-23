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
    let placeInfoView = PlaceInfoView()
    
    let selectCategoryLabel = UILabel()
    var categoryButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        let button = UIButton()
        configuration.baseForegroundColor = Color.black
        configuration.baseBackgroundColor = Color.white
        configuration.title = FilterItem.allCases[0].title
        configuration.image = Image.arrowDown
        configuration.image?.withTintColor(Color.black)
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8
        button.configuration = configuration
        button.showsMenuAsPrimaryAction = true
        button.isUserInteractionEnabled = true
        button.isEnabled = true
        return button
    }()
    
    lazy var selectedCategorySubject = BehaviorSubject(value: categoryButton.configuration?.title ?? "")
    
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([placeInfoView, selectCategoryLabel, categoryButton])
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
            make.bottom.greaterThanOrEqualToSuperview().offset(-12)
        }
        categoryButton.snp.makeConstraints { make in
            make.centerY.equalTo(selectCategoryLabel)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(24)
            categoryButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            make.bottom.greaterThanOrEqualToSuperview().offset(-12)
        }
    }
    override func configureView() {
        super.configureView()
        contentView.isUserInteractionEnabled = true
        
        selectCategoryLabel.design(text: "카테고리", font: .pretendard(size: 18, weight: .semiBold))
        
        configureCategoryMenu()
    }
    
    private func configureCategoryMenu() {
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
}
