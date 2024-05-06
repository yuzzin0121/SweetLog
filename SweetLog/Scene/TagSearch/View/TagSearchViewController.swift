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
    
    var lastContentOffset: CGFloat = 0 // 스크롤 방향 감지를 위한 변수
    var isLoading = false // 현재 데이터 로딩 중인지 확인

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let prefetchTrigger = PublishRelay<Void>()
        let input = TagSearchViewModel.Input(viewDidLoadTrigger: Observable.just(()),
                                             searchText: mainView.tagSearchBar.rx.text.orEmpty.asObservable(),
                                             searchButtonTap: mainView.tagSearchBar.rx.searchButtonClicked.asObservable(), 
                                             prefetchTrigger: prefetchTrigger.asObservable(), 
                                             refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged).asObservable())
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(mainView.tagCollectionView.rx.items(cellIdentifier: TagPostCollectionViewCell.identifier, cellType: TagPostCollectionViewCell.self)) { index, postItem, cell in
                cell.configureCell(postItem: postItem)
            }
            .disposed(by: disposeBag)
        
        output.postList
            .drive(with: self) { owner, _ in
                owner.mainView.endRefreshing()
                owner.isLoading = false
            }
            .disposed(by: disposeBag)
        
        mainView.tagCollectionView.rx.modelSelected(FetchPostItem.self)
            .asDriver()
            .drive(with: self) { owner, postItem in
                owner.showPostDetailVC(postId: postItem.postId)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainView.tagCollectionView.rx.prefetchItems, output.postList.asObservable())
            .subscribe(with: self) { owner, prefetchInfo in
                guard !owner.isLoading else { return }
                if let maxIndexPath = prefetchInfo.0.max(by: { $0.row < $1.row }) {
                    guard maxIndexPath.item == prefetchInfo.1.count - 3 else { return }
                    print("일치함!!! - 프리패치 인덱스: \(maxIndexPath), 일치해야될 인덱스: \(prefetchInfo.1.count - 3)")
                    owner.isLoading = true
                    prefetchTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showPostDetailVC(postId: String) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.viewModel.postId = postId
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
}

extension TagSearchViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > lastContentOffset {
           // 아래로 스크롤
            isLoading = false
        } else if scrollView.contentOffset.y < lastContentOffset {
           // 위로 스크롤
            isLoading = true // 데이터 로딩 방지
        }

        lastContentOffset = scrollView.contentOffset.y
    }
}
