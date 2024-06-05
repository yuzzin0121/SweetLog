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
        let fetchPostsTrigger: Observable<Void>
        let refreshControlTrigger: Observable<Void>
    }
    
    struct Output {
        let filterList: Driver<[FilterItem]>
        let postList: Driver<[FetchPostItem]>
        let postCellTapped: Driver<String>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let filterList = BehaviorRelay<[FilterItem]>(value: FilterItem.allCases)
        let currentCategory = PublishSubject<String>()
        let fetchPostsTrigger = PublishSubject<Void>()
        let postList = BehaviorRelay<[FetchPostItem]>(value: [])
        let postCellTapped = PublishRelay<String>() // postId
        let next = BehaviorSubject(value: "")
        let likeIndex = BehaviorRelay<Int?>(value: nil)
        let errorMessage = PublishRelay<String>()
        
        // 카테고리 클릭 시
        input.filterItemClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { value in
                return FilterItem(rawValue: value)!
            }
            .map { [weak self] in
                guard let self else { return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil) }
                selectedCategory.accept($0.title)
                filterList.accept(self.filterList)
                currentCategory.onNext($0.title)
                return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil)
            }
            .flatMap { fetchPostQuery in
                return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchPosts(query: fetchPostQuery))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let fetchPostModel):
                    postList.accept(fetchPostModel.data)
                    next.onNext(fetchPostModel.nextCursor)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlTrigger
            .bind { _ in
                NotificationCenter.default.post(name: .fetchPosts, object: nil, userInfo: nil)
            }
            .disposed(by: disposeBag)
        
        input.fetchPostsTrigger
            .withLatestFrom(input.filterItemClicked)
            .map { value in
                return FilterItem(rawValue: value)!
            }
            .map { [weak self] in
                guard let self else { return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil) }
                selectedCategory.accept($0.title)
                currentCategory.onNext($0.title)
                filterList.accept(self.filterList)
                return FetchPostQuery(next: nil, product_id: $0.title, hashTag: nil)
            }
            .flatMap { fetchPostQuery in
                return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchPosts(query: fetchPostQuery))
            }
            .debug()
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let fetchPostModel):
                    print("받았음")
                    postList.accept(fetchPostModel.data)
                    next.onNext(fetchPostModel.nextCursor)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
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
                    return Single<Result<FetchPostModel, Error>>.never()
                } else {
                    return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchPosts(query: fetchPostQuery))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let fetchPostModel):
                    print("prefetch - next: \(fetchPostModel.nextCursor)")
                    if fetchPostModel.nextCursor ==  "" {
                        postList.accept(fetchPostModel.data)
                    } else {
                        var tempList = postList.value
                        tempList.append(contentsOf: fetchPostModel.data)
                        postList.accept(tempList)
                    }
                    next.onNext(fetchPostModel.nextCursor)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 포스트 셀 클릭 시 포스트 아이디 emit
        input.postCellTapped
            .subscribe { fetchPostItem in
                guard let postId = fetchPostItem.element?.postId else { return }
                postCellTapped.accept(postId)
            }
            .disposed(by: disposeBag)
        
        
        // 좋아요 클릭했을 때
        input.likeObservable
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { index, isClicked in
                let postItem = postList.value[index]    // 좋아요 클릭한 포스트
                likeIndex.accept(index)
                print("요청")
                return NetworkManager.shared.requestToServer(model: LikeStatusModel.self, router: PostRouter.likePost(postId: postItem.postId, likeStatusModel: LikeStatusModel(likeStatus: isClicked)))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let likeStatusModel):
                    guard let likeIndex = likeIndex.value else { return }
                    let likeStatus = likeStatusModel.likeStatus
                    let changedPostList = owner.changeLikeStatus(isLike: likeStatus, likeIndex: likeIndex, postList: postList.value)
                    postList.accept(changedPostList)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
       
        
        return Output(filterList: filterList.asDriver(onErrorJustReturn: []),
                      postList: postList.asDriver(onErrorJustReturn: []),
                      postCellTapped: postCellTapped.asDriver(onErrorJustReturn: ""),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    private func changeLikeStatus(isLike: Bool, likeIndex: Int, postList: [FetchPostItem]) -> [FetchPostItem] {
        var postList = postList
        if isLike {
            postList[likeIndex].likes.append(UserDefaultManager.shared.userId)
        } else {
            if let index = postList[likeIndex].likes.firstIndex(where: { $0 == UserDefaultManager.shared.userId }) {
                postList[likeIndex].likes.remove(at: index)
            }
        }
        return postList
    }
}


extension HomeViewModel {
    @objc
    private func fetchPosts() {
        print(#function)
        fetchPostsTrigger.onNext(())
    }
}
