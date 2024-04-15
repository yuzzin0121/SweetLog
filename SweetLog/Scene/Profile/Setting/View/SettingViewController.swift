//
//  SettingViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingViewController: BaseViewController {
    let mainView = SettingView()
    
    let viewModel = SettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width, height: 50)
        layout.scrollDirection = .vertical
        mainView.collectionView.collectionViewLayout = layout
    }
    
    override func bind() {
        viewModel.settingItemList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: SettingCollectionViewCell.identifier, cellType: SettingCollectionViewCell.self)) {item,model,cell in
                cell.configureCell(item: model)
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(mainView.collectionView.rx.itemSelected, mainView.collectionView.rx.modelSelected(SettingItem.self))
//            .bind(with: self) { owner, value in
//                switch value.0 {
//                case SettingItem.withdraw.rawValue:
//                    owner.showAlert(title: "탈퇴", message: "정말로 탈퇴하시겠습니까?", actionTitle: "탈퇴하기", actionHandler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
//
//                }
//            }
//            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "설정"
    }
    
    override func loadView() {
        view = mainView
    }
}
