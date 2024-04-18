//
//  HomeViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit
import RxSwift


final class HomeViewController: BaseViewController {
    let mainView = HomeView()
    
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func bind() {
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()))
        let output = viewModel.transform(input: input)
        
        output.outputPostList
            .drive(mainView.collectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) {index,item,cell in
                cell.configureCell(fetchPostItem: item)
                cell.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 300)
        layout.scrollDirection = .vertical
        mainView.collectionView.collectionViewLayout = layout
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.titleLabel)
    }
   
}
