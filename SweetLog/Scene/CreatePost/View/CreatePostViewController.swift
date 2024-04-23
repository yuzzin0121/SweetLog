//
//  CreatePostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

class CreatePostViewController: BaseViewController {
    private let mainView = CreatePostView()
    
    let viewModel = CreatePostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "리뷰 작성"
    }
    
    override func loadView() {
        view = mainView
    }

}
