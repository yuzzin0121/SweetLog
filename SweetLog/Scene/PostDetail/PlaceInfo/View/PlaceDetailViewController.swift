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
        
        output.placeInfo
            .drive(with: self) { owner, placeInfo in
               let (linkMetaData, coord, placeName, address) = placeInfo
                owner.mainView.setLinkView(metaData: linkMetaData)
                owner.mainView.setCoordinate(center: coord, placeName: placeName)
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
