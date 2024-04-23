//
//  CreatePostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit
import RxSwift

class CreatePostViewController: BaseViewController {
    private let mainView = CreatePostView()
    private var menuChildren: [UIMenuElement] = []
    let viewModel = CreatePostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    override func bind() {
        let sugarContent = BehaviorSubject(value: 1)
        
        for button in mainView.buttonList {
            button.rx.tap
                .subscribe(with: self) { owner, _ in
                    owner.mainView.selectSugarButton(button.tag)
                    sugarContent.onNext(button.tag)
                }
                .disposed(by: disposeBag)
        }
        
        let input = CreatePostViewModel.Input(sugarContent: sugarContent.asObserver())
        let output = viewModel.transform(input: input)
    }
    
    // 선택한 장소 뷰에 반영
    private func setData() {
        guard let placeItem = viewModel.placeItem else { return }
        mainView.placeInfoView.addressLabel.text = placeItem.address
        mainView.placeInfoView.placeNameLabel.text = placeItem.placeName
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "리뷰 작성"
    }
    
    override func loadView() {
        view = mainView
    }

}
