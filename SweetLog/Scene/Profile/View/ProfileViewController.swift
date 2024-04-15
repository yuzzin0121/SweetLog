//
//  ProfileViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class ProfileViewController: BaseViewController {
    lazy var settingButton = UIBarButtonItem(image: Image.setting, style: .plain, target: self, action: nil)
    let mainView = ProfileView()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        
        settingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSettingVC()
            }
            .disposed(by: disposeBag)
    }
    
    private func showSettingVC() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "내 프로필"
        navigationItem.rightBarButtonItem = settingButton
    }
}
