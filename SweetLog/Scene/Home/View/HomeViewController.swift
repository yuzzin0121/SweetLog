//
//  HomeViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    let mainView = HomeView()
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let filterItemClicked = BehaviorSubject(value: 0)
        
        viewModel.filterList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.filterCollectionView.rx.items(cellIdentifier: FilterCollectionViewCell.identifier, cellType: FilterCollectionViewCell.self)) { index, item, cell in
                cell.configureCell(item: item)
                cell.filterButton.tag = index
                cell.filterButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        print(item)
                        filterItemClicked.onNext(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()), filterItemClicked: filterItemClicked.asObserver())
        let output = viewModel.transform(input: input)
        
            
        output.outputPostList
            .drive(mainView.postCollectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) {index,item,cell in
                cell.configureCell(fetchPostItem: item)
                cell.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        mainView.filterCollectionView.collectionViewLayout = filterLayout
        
        let postlayout = UICollectionViewFlowLayout()
        postlayout.itemSize = CGSize(width: view.frame.width - 40, height: 280)
        postlayout.scrollDirection = .vertical
        mainView.postCollectionView.collectionViewLayout = postlayout

    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.titleLabel)
    }
   
}
