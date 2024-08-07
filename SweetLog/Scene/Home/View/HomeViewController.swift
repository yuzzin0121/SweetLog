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
    var lastContentOffset: CGFloat = 0 // 스크롤 방향 감지를 위한 변수
    var isLoading = false // 현재 데이터 로딩 중인지 확인

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func bind() {
        
        let filterItemClicked = BehaviorSubject(value: 0)
        
        let likeTapped = PublishSubject<(Int, Bool)>()
        let prefetchTrigger = PublishRelay<Void>()
        
        let input = HomeViewModel.Input(viewDidLoad: Observable.just(()), 
                                        filterItemClicked: filterItemClicked,
                                        postCellTapped: mainView.postCollectionView.rx.modelSelected(FetchPostItem.self),
                                        likeObservable: likeTapped.asObservable(),
                                        prefetchTrigger: prefetchTrigger.asObservable(),
                                        fetchPostsTrigger: viewModel.fetchPostsTrigger.asObservable(),
                                        refreshControlTrigger: mainView.refreshControl.rx.controlEvent(.valueChanged).asObservable())
        let output = viewModel.transform(input: input)
        
        output.filterList
            .drive(mainView.filterCollectionView.rx.items(cellIdentifier: FilterCollectionViewCell.identifier, cellType: FilterCollectionViewCell.self)) { [weak self] index, item, cell in
                guard let self else { return }
                cell.configureCell(item: item, selectedCategory: self.viewModel.selectedCategory.value)
                cell.filterButton.tag = index
                cell.filterButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        filterItemClicked.onNext(index)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        filterItemClicked
            .subscribe(with: self) { owner, _ in
                owner.lastContentOffset = 0
                owner.isLoading = false
            }
            .disposed(by: disposeBag)
        
        output.postList
            .drive(mainView.postCollectionView.rx.items(cellIdentifier: PostCollectionViewCell.identifier, cellType: PostCollectionViewCell.self)) {index,item,cell in
                cell.configureCell(fetchPostItem: item)
                cell.likeButton.rx.tap  // 좋아요 버튼 클릭 시
                    .subscribe(with: self) { owner, _ in
                        cell.likeButton.isSelected.toggle()
                        likeTapped.onNext((index, cell.likeButton.isSelected))
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
        
        output.postList
            .drive(with: self) { owner, _ in
                owner.mainView.endRefreshing()
                owner.isLoading = false
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(mainView.postCollectionView.rx.prefetchItems, output.postList.asObservable())
            .subscribe(with: self) { owner, prefetchInfo in
                guard !owner.isLoading else { return }
                if let maxIndexPath = prefetchInfo.0.max(by: { $0.row < $1.row }) {
                    guard maxIndexPath.item == prefetchInfo.1.count - 2 else { return }
                    owner.isLoading = true
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
        
        mainView.showChatRoomButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.showChatroomListVC()
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
        let profileVC = ProfileViewController(isMyProfile: userId == UserDefaultManager.shared.userId, userId: userId, isDetail: true)
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
    
    private func showChatroomListVC() {
        let chatRoomListVC = ChatRoomListViewController()
        navigationController?.pushViewController(chatRoomListVC, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
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

