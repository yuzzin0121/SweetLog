//
//  PlaceDetailViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import UIKit
import RxSwift

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
    
    override func bind() {
        let input = PlaceDetailViewModel.Input(fetchPlaceTrigger: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.fetchPlaceInfo
            .drive(with: self) { owner, fetchPostItem in
                print("fetchPlaceInfo")
            }
            .disposed(by: disposeBag)
        
        output.linkMetaData
            .drive(with: self) { owner, linkMetaData in
                guard let linkMetaData else { return }
                owner.mainView.setLinkView(metaData: linkMetaData)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "장소 상세 정보"
    }
    
}
