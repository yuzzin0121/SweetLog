//
//  CreatePostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import UIKit

class CreatePostViewController: BaseViewController {
    private let mainView = CreatePostView()
    private var menuChildren: [UIMenuElement] = []
    let viewModel = CreatePostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setData()
    }
    
    override func bind() {
        
    }
    
    private func setData() {
        guard let placeItem = viewModel.placeItem else { return }
        mainView.placeInfoView.addressLabel.text = placeItem.address
        mainView.placeInfoView.placeNameLabel.text = placeItem.placeName
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "리뷰 작성"
    }
    
    override func loadView() {
        view = mainView
    }

}
