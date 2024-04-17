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
        let withdrawTapped = PublishSubject<Void>()
        
        viewModel.settingItemList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: SettingCollectionViewCell.identifier, cellType: SettingCollectionViewCell.self)) {item,model,cell in
                cell.configureCell(item: model)
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.modelSelected(SettingItem.self)
            .subscribe(with: self) { owner, settingItem in
                switch settingItem {
                case .withdraw:
                    owner.showAlert(title: "탈퇴", message: "정말로 계정을 탈퇴하시겠습니까?", actionTitle: "탈퇴하기") {
                        withdrawTapped.onNext(())
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        let input = SettingViewModel.Input(withdrawTapped: withdrawTapped.asObserver())
        let output = viewModel.transform(input: input)
        
        output.withdrawSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.changeRootView(to: SignInViewController(), isNav: true)
            }
            .disposed(by: disposeBag)
        
        output.errorString
            .drive(with: self) { owner, errorString in
                owner.showAlert(title: "에러", message: errorString)
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert(title: String, message: String, actionTitle: String, actionHandler: (() -> Void)? ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: actionTitle, style: .destructive) { _ in
            actionHandler?()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "설정"
    }
    
    override func loadView() {
        view = mainView
    }
}
