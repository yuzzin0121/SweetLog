//
//  PostDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import UIKit

final class PostDetailViewController: BaseViewController {
    let mainView = PostDetailView()
    let viewModel = PostDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func loadView() {
        view = mainView
    }
}
