//
//  PlaceInfoViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import UIKit
import RxSwift

final class PlaceInfoViewController: BaseViewController {
    let mainView = PlaceDetailInfoView()
    let viewModel: PlaceInfoViewModel
    
    init(placeItem: PlaceItem) {
        viewModel = PlaceInfoViewModel(placeItem: placeItem)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func bind() {
        let input = PlaceInfoViewModel.Input(placeItem: Observable.just(viewModel.placeItem))
        let output = viewModel.transform(input: input)
        
        output.placeItem
            .drive(with: self) { owner, placeInfo in
                let (placeItem, meta) = placeInfo
                owner.mainView.setPlaceItem(placeItem, meta: meta)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }

    override func loadView() {
        view = mainView
    }
}
