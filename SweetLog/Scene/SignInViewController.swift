//
//  SignInViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class SignInViewController: BaseViewController {
    let mainView = SignInView()
    
    let viewModel = SignInViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func bind() {
        
        
        mainView.signUpButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSignUpVC()
            }
            .disposed(by: disposeBag)
    }
    
    private func showSignUpVC() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
}
