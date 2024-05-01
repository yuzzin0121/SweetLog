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
                        filterItemClicked.onNext(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        let likeIndex = PublishRelay<Int>()
        let likeStatus = PublishRelay<Bool>()
        let likeObservable = Observable.zip(likeIndex, likeStatus)
        let prefetchTrigger = PublishRelay<Void>()
        
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()), 
                                        filterItemClicked: filterItemClicked,
                                        postCellTapped: mainView.postCollectionView.rx.modelSelected(FetchPostItem.self),
                                        likeObservable: likeObservable,
                                        prefetchTrigger: prefetchTrigger.asObservable())
        let output = viewModel.transform(input: input)
        
        // 
        output.postList
            .drive(mainView.postCollectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) {index,item,cell in
                cell.configureCell(fetchPostItem: item)
                cell.likeButton.rx.tap  // 좋아요 버튼 클릭 시
                    .subscribe(with: self) { owner, _ in
                        cell.likeButton.isSelected.toggle()
                        likeIndex.accept(index)
                        likeStatus.accept(cell.likeButton.isSelected)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.userNicknameButton.rx.tap  // 닉네임 클릭 시
                    .subscribe(with: self) { owner, _ in
                        owner.showProfileVC(userId: item.creator.userId)
                    }
                    .disposed(by: cell.disposeBag)
                
                let profileTapGesture = ProfileTapGestureRecognizer(target: self, action: #selector(self.profileImageTapped))
                profileTapGesture.userId = item.creator.userId
                cell.profileImageView.addGestureRecognizer(profileTapGesture)
                cell.profileImageView.isUserInteractionEnabled = true
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainView.postCollectionView.rx.prefetchItems, output.postList.asObservable())
            .subscribe(with: self) { owner, prefetchInfo in
                guard let indexPath = prefetchInfo.0.first else { return }
                guard indexPath.item == prefetchInfo.1.count - 2 else { return }
                prefetchTrigger.accept(())
            }
            .disposed(by: disposeBag)
      
        mainView.postCollectionView.rx.prefetchItems
            .subscribe(with: self) { owner, indexPath in
                guard let indexPath = indexPath.first else { return }
                print(indexPath.item)
                if indexPath.item == 4 {
                    prefetchTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        // 게시물 셀 클릭 시
        output.postCellTapped
            .drive(with: self) { owner, postId in
                owner.showPostDetailVC(postId: postId)
            }
            .disposed(by: disposeBag)
        
        // + 버튼 클릭 시
        mainView.addPostButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showSelectPlaceVC()
            }
            .disposed(by: disposeBag)
    }
    
    @objc
    private func profileImageTapped(_ sender: ProfileTapGestureRecognizer) {
        let userId = sender.userId
        showProfileVC(userId: userId)
    }
    
    private func showProfileVC(userId: String?) {
        guard let userId else { return }
        let profileVC = ProfileViewController(isMyProfile: userId == UserDefaultManager.shared.userId, userId: userId)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func showPostDetailVC(postId: String) {
        let postDetailVC = PostDetailViewController()
        postDetailVC.viewModel.postId = postId
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    private func showSelectPlaceVC() {
        let selectPlaceVC = SelectPlaceViewController()
        navigationController?.pushViewController(selectPlaceVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let filterLayout = UICollectionViewFlowLayout()
        filterLayout.scrollDirection = .horizontal
        filterLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        mainView.filterCollectionView.collectionViewLayout = filterLayout
        
        let postlayout = UICollectionViewFlowLayout()
        postlayout.itemSize = CGSize(width: view.frame.width - 40, height: 280)
        postlayout.minimumLineSpacing = 18
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
