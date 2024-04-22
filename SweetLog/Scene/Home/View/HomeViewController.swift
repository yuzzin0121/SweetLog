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
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        viewModel.filterList
            .asDriver(onErrorJustReturn: [])
            .drive(mainView.filterCollectionView.rx.items(cellIdentifier: FilterCollectionViewCell.identifier, cellType: FilterCollectionViewCell.self)) { index, item, cell in
                cell.configureCell(item: item)
                cell.filterButton.tag = index
                
            }
            .disposed(by: disposeBag)
        
        
        Observable.zip(mainView.filterCollectionView.rx.itemSelected, mainView.filterCollectionView.rx.modelSelected(FilterItem.self))
            .bind(with: self) { owner, value in
                print(value.1)
            }
            .disposed(by: disposeBag)
            
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
        filterLayout.itemSize = CGSize(width: view.frame.width - 40, height: 50)
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
