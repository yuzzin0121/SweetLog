//
//  TagSearchViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

class TagSearchViewController: BaseViewController {
    let mainView = TagSearchView()
    let viewModel = TagSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        let input = TagSearchViewModel.Input()
        let output = viewModel.transform(input: input)
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "검색"
    }
}
