//
//  SignUpViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class SignUpViewController: BaseViewController {
    let mainView = SignUpView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "회원가입"
    }
    
    override func loadView() {
        view = mainView
    }

}
