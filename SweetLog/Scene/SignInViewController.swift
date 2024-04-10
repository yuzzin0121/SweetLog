//
//  SignInViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

final class SignInViewController: BaseViewController {
    let mainView = SignInView()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func loadView() {
        view = mainView
    }
}
