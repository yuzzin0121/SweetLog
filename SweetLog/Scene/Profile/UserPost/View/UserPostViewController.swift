//
//  UserPostViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import UIKit
import RxSwift

class UserPostViewController: BaseViewController {
    let mainView = UserPostView()
    
    let viewModel = UserPostViewModel()
    let fetchPostsTrigger = PublishSubject<Void>()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPostsTrigger.onNext(())
    }
    
    override func bind() {
        let input = UserPostViewModel.Input(fetchPostTrigger: fetchPostsTrigger.asObserver(), 
                                            postCellTapped: mainView.collectionView.rx.modelSelected(FetchPostItem.self).asObservable())
        let output = viewModel.transform(input: input)
        
        output.fetchPostList
            .drive(mainView.collectionView.rx.items(cellIdentifier: UserPostCollectionViewCell.identifier, cellType: UserPostCollectionViewCell.self)) { index, postItem, cell in
                cell.configureCell(postItem: postItem)
            }
            .disposed(by: disposeBag)
        
        output.postCellTapped
            .drive(with: self) { owner, postId in
                owner.showPostDetailVC(postId: postId)
            }
            .disposed(by: disposeBag)
    }
    
    private func showPostDetailVC(postId: String) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.viewModel.postId = postId
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        let itemSize = (view.frame.width - 40 - 16) / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        mainView.collectionView.collectionViewLayout = layout
    }

    override func loadView() {
        view = mainView
    }
}
