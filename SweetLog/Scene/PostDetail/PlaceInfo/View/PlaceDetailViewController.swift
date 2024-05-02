//
//  PlaceDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import UIKit

final class PlaceDetailViewController: BaseViewController {
    let mainView = PlaceDetailView()
    let viewModel: PlaceDetailViewModel
    
    init(postItem: FetchPostItem) {
        viewModel = PlaceDetailViewModel(postItem: postItem)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "장소 상세 정보"
    }
    
}
