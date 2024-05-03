//
//  HomeViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    let filterList = FilterItem.allCases
    let selectedCategory = BehaviorRelay(value: FilterItem.bread.title)
    var disposeBag = DisposeBag()
    let fetchPostsTrigger = PublishSubject<Void>()
    let deletePostTrigger = PublishSubject<String>()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(fetchPosts), name: .fetchPosts, object: nil)
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let filterItemClicked: Observable<Int>
        let postCellTapped: ControlEvent<FetchPostItem>
        let likeObservable: Observable<(Int, Bool)>
        let prefetchTrigger: Observable<Void>
    }
    
    struct Output {
        let filterList: Driver<[FilterItem]>
        let postList: Driver<[FetchPostItem]>
        let postCellTapped: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let filterList = BehaviorRelay<[FilterItem]>(value: FilterItem.allCases)
        let currentCategory = PublishSubject<String>()
        let fetchPostsTrigger = PublishSubject<Void>()
        let postList = BehaviorRelay<[FetchPostItem]>(value: [])
        let postCellTapped = PublishRelay<String>() // postId
        var postListValue: [FetchPostItem] = []
        let next = BehaviorSubject(value: "")
        var likeIndex: Int?
        
        deletePostTrigger
            .subscribe(with: self) { owner, postId in
                let deletedPostList = owner.deletePost(postList: postListValue, postId: postId)
                postList.accept(deletedPostList)
                postListValue = deletedPostList
            }
            .disposed(by: disposeBag)
        
        
        // 카테고리 클릭 시
        input.filterItemClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { index in
                return FilterItem(rawValue: index)!
            }
            .map { [weak self] in
                guard let self else { return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil) }
                selectedCategory.accept($0.title)
                currentCategory.onNext($0.title)
                filterList.accept(self.filterList)
                return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil)
            }
            .flatMap { fetchPostQuery in
                return PostNetworkManager.shared.fetchPosts(fetchPostQuery: fetchPostQuery)
            }
            .subscribe(with: self) { owner, fetchPostModel in
                postList.accept(fetchPostModel.data)
                postListValue = fetchPostModel.data
//                print("커서 값 - \(fetchPostModel.nextCursor)")
                next.onNext(fetchPostModel.nextCursor)
            }
            .disposed(by: disposeBag)
        
        input.prefetchTrigger
            .withLatestFrom(Observable.combineLatest(next, currentCategory))
            .map { prefetchInfo in
                return FetchPostQuery(next: prefetchInfo.0, product_id: prefetchInfo.1, hashTag: nil)
            }
            .flatMap { fetchPostQuery in
//                print("현재 커서값 \(fetchPostQuery.next)")
                if fetchPostQuery.next == "0" {
                    return Single<FetchPostModel>.never()
                } else {
                    return PostNetworkManager.shared.fetchPosts(fetchPostQuery: fetchPostQuery)
                        .catch { error in
                            return Single<FetchPostModel>.never()
                        }
                }
            }
            .subscribe(with: self) { owner, fetchPostModel in
                print("prefetch - next: \(fetchPostModel.nextCursor)")
                if fetchPostModel.nextCursor ==  "" {
                    postList.accept(fetchPostModel.data)
                } else {
                    var tempList = postList.value
                    tempList.append(contentsOf: fetchPostModel.data)
                    postListValue = tempList
                    postList.accept(tempList)
                }
                next.onNext(fetchPostModel.nextCursor)
            }
            .disposed(by: disposeBag)
        
        
        // 포스트 셀 클릭 시 포스트 아이디 emit
        input.postCellTapped
            .subscribe { fetchPostItem in
                guard let postId = fetchPostItem.element?.postId else { return }
                postCellTapped.accept(postId)
            }
            .disposed(by: disposeBag)
        
        let likeClicked = Observable.combineLatest(input.likeObservable, postList)
        
        // 좋아요 클릭했을 때
        likeClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { value, list in
                let postItem = list[value.0]    // 좋아요 클릭한 포스트
                likeIndex = value.0
                return PostNetworkManager.shared.likePost(postId: postItem.postId, likeStatusModel: LikeStatusModel(likeStatus: value.1))
                    .catch { error in
                        print(error.localizedDescription)
                        return Single<LikeStatusModel>.never()
                    }
            }
            .subscribe(with: self) { owner, likeStatusModel in
                guard let likeIndex else { return }
                let likeStatus = likeStatusModel.likeStatus
                var postItem = postListValue[likeIndex]
                if likeStatus == true {
                    postItem.likes.append(UserDefaultManager.shared.userId)
                } else {
                    if let index = postItem.likes.firstIndex(where: { $0 == UserDefaultManager.shared.userId }) {
                        postItem.likes.remove(at: index)
                    }
                }
                postListValue[likeIndex] = postItem
                postList.accept(postListValue)
            }
            .disposed(by: disposeBag)
        
       
        
        return Output(filterList: filterList.asDriver(onErrorJustReturn: []),
                      postList: postList.asDriver(onErrorJustReturn: []),
                      postCellTapped: postCellTapped.asDriver(onErrorJustReturn: ""))
    }
}

extension HomeViewModel {
    @objc
    private func fetchPosts() {
        fetchPostsTrigger.onNext(())
    }
    
    
    func emitDeletePostTrigger(_ postId: String) {
        deletePostTrigger.onNext(postId)
    }
    
    func deletePost(postList: [FetchPostItem], postId: String) -> [FetchPostItem] {
        print(#function)
        var postList = postList
        if let index = postList.firstIndex(where: { $0.postId == postId }) {
            postList.remove(at: index)
        }
        return postList
    }
}
