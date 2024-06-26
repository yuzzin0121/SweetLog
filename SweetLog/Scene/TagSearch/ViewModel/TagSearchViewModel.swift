//
//  TagSearchViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class TagSearchViewModel: ViewModelType {
    let deletePostTrigger = PublishSubject<String>()
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let searchText: Observable<String>
        let searchButtonTap: Observable<Void>
        let prefetchTrigger: Observable<Void>
        let refreshControlTrigger: Observable<Void>
    }
    
    struct Output {
        let postList: Driver<[FetchPostItem]>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let postList = BehaviorRelay<[FetchPostItem]>(value: [])
        let next = BehaviorSubject(value: "")
        let errorMessage = PublishRelay<String>()
        
        input.searchText
            .bind { text in
                if text.isEmpty {
                    postList.accept([])
                }
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map { searchText in
                let seatchText = searchText.trimmingCharacters(in: [" "])
                print(searchText)
                let query = FetchPostQuery(next: nil, limit: "20", product_id: nil, hashTag: seatchText)
                return query
            }
            .flatMap {
                return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.searchHashtag(query: $0))
            }
            .bind { result in
                switch result {
                case .success(let fetchPostModel):
                    next.onNext(fetchPostModel.nextCursor)
                    postList.accept(fetchPostModel.data)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlTrigger
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map { searchText in
                let seatchText = searchText.trimmingCharacters(in: [" "])
                print(searchText)
                let query = FetchPostQuery(next: nil, limit: "20", product_id: nil, hashTag: seatchText)
                return query
            }
            .flatMap {
                return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.searchHashtag(query: $0))
            }
            .bind { result in
                switch result {
                case .success(let fetchPostModel):
                    next.onNext(fetchPostModel.nextCursor)
                    postList.accept(fetchPostModel.data)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        deletePostTrigger
            .bind (with: self) { owner, postId in
                let listValue = postList.value
                let deletedPostList = owner.deletePost(postList: listValue, postId: postId)
                postList.accept(deletedPostList)
            }
            .disposed(by: disposeBag)
        
        input.prefetchTrigger
            .withLatestFrom(Observable.combineLatest(next, input.searchText))
            .map { prefetchInfo in
                return FetchPostQuery(next: prefetchInfo.0, limit: "25", product_id: nil, hashTag: prefetchInfo.1)
            }
            .flatMap { fetchPostQuery in
//                print("현재 커서값 \(fetchPostQuery.next)")
                if fetchPostQuery.next == "0" {
                    return Single<Result<FetchPostModel, Error>>.never()
                } else {
                    return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.searchHashtag(query: fetchPostQuery))
                }
            }
            .bind { result in
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
                    print(error)
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(postList: postList.asDriver(onErrorJustReturn: []),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    func emitDeletePostTrigger(postId: String) {
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
