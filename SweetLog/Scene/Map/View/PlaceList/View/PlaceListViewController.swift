//
//  PlaceListViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class PlaceListViewController: BaseViewController {
    let mainView = PlaceListView()
    let viewModel = PlaceListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let input = PlaceListViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.searchText
            .drive(with: self) { owner, searchText in
                owner.mainView.setSearchText(searchText)
            }
            .disposed(by: disposeBag)
        
        output.placeList
            .drive(mainView.placeTableView.rx.items(cellIdentifier: PlaceTableViewCell.identifier, cellType: PlaceTableViewCell.self)) { index, placeItem, cell in
                cell.selectionStyle = .none
                cell.configureCell(placeItem: placeItem)
            }
            .disposed(by: disposeBag)
        
        output.placeList
            .drive(with: self) { owner, placeList in
                print(placeList)
                owner.mainView.setResult(resultCount: placeList.count)
                owner.mainView.setEmpty(placeList.isEmpty)
            }
            .disposed(by: disposeBag)
        
        mainView.placeTableView.rx.modelSelected(PlaceItem.self)
            .asDriver()
            .drive(with: self) { owner, placeItem in
                owner.showPlaceInfoVC(placeItem: placeItem)
            }
            .disposed(by: disposeBag)
    }
    
    private func showPlaceInfoVC(placeItem: PlaceItem) {
        let placeInfoVC = PlaceInfoViewController(placeItem: placeItem)
        navigationController?.pushViewController(placeInfoVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }

    override func configureNavigationItem() {
    }
}
