//
//  TagSearchViewController.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit
import RxSwift
import RxCocoa

class TagSearchViewController: BaseViewController {
    let mainView = TagSearchView()
    let viewModel = TagSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func bind() {
        let input = TagSearchViewModel.Input(viewDidLoadTrigger: Observable.just(()),
                                             searchText: mainView.tagSearchBar.rx.text.orEmpty.asObservable(),
                                             searchButtonTap: mainView.tagSearchBar.rx.searchButtonClicked.asObservable())
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(mainView.tagCollectionView.rx.items(cellIdentifier: TagPostCollectionViewCell.identifier, cellType: TagPostCollectionViewCell.self)) { index, postItem, cell in
                cell.configureCell(postItem: postItem)
            }
            .disposed(by: disposeBag)
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
