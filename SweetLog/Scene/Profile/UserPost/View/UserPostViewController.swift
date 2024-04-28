//
//  UserPostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit

class UserPostViewController: BaseViewController {
    let mainView = UserPostView()
    
    let viewModel = UserPostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func bind() {
        
    }

    override func loadView() {
        view = mainView
    }
}
