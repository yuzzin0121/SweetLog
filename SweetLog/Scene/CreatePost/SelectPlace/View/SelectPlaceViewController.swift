//
//  SelectPlaceViewController.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectPlaceViewController: BaseViewController {
    let mainView = SelectPlaceView()
    
    let viewModel = SelectPlaceViewModel()
    var lastContentOffset: CGFloat = 0 // 스크롤 방향 감지를 위한 변수
    var isLoading = false // 현재 데이터 로딩 중인지 확인

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        let prefetchTrigger = PublishRelay<Void>()
        let input = SelectPlaceViewModel.Input(searchButtonTap: mainView.searchBar.rx.searchButtonClicked.asObservable(),
                                               searchText: mainView.searchBar.rx.text.orEmpty.asObservable(), prefetchTrigger: prefetchTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.placeList
            .drive(mainView.placeCollectionView.rx.items(cellIdentifier: PlaceCollectionViewCell.identifier, cellType: PlaceCollectionViewCell.self)) { index, item, cell in
                cell.configureCell(item)
            }
            .disposed(by: disposeBag)
        
        
        mainView.placeCollectionView.rx.modelSelected(PlaceItem.self)
            .bind(with: self) { owner, placeItem in
                print("클릭")
                owner.showCreatePostVC(placeItem: placeItem)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainView.placeCollectionView.rx.prefetchItems, output.placeList.asObservable())
            .subscribe(with: self) { owner, prefetchInfo in
                if let maxIndexPath = prefetchInfo.0.max(by: { $0.row < $1.row }) {
                    guard maxIndexPath.item == prefetchInfo.1.count - 1 else { return }
                    owner.isLoading = true
                    prefetchTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func showCreatePostVC(placeItem: PlaceItem) {
        let createPostVC = CreatePostViewController(placeItem: placeItem, postItem: nil, cuMode: .create)
        navigationController?.pushViewController(createPostVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(view.frame.width - 40, 60)
        layout.scrollDirection = .vertical
        mainView.placeCollectionView.collectionViewLayout = layout
    }
    
    override func configureNavigationItem() {
        navigationItem.title = "후기 작성"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.arrowLeft, style: .plain, target: self, action: #selector(self.popView))
    }

}

extension SelectPlaceViewController: UICollectionViewDelegate {
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
