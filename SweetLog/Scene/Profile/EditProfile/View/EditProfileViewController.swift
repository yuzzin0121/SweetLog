//
//  EditProfileViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit

class EditProfileViewController: BaseViewController {
    let mainView = EditProfileView()
    
    let viewModel = EditProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func configureNavigationItem() {
        navigationItem.title = "프로필 수정"
    }
    
    override func loadView() {
        view = mainView
    }
}
