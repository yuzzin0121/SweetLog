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
    }
    
    struct Output {
        let postList: Driver<[FetchPostItem]>
    }
    
    func transform(input: Input) -> Output {
        let postList = BehaviorRelay<[FetchPostItem]>(value: [])
        let next = BehaviorSubject(value: "")
        
        input.searchText
            .subscribe(with: self) { owner, text in
                postList.accept([])
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
                return PostNetworkManager.shared.searchTagPosts(fetchPostQuery: $0)
                    .catch { error in
                        return Single<FetchPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, fetchPostModel in
                print("검색된 포스트 개수 \(fetchPostModel.data.count)")
                next.onNext(fetchPostModel.nextCursor)
                postList.accept(fetchPostModel.data)
            }
            .disposed(by: disposeBag)
        
        deletePostTrigger
            .subscribe(with: self) { owner, postId in
                let listValue = postList.value
                let deletedPostList = owner.deletePost(postList: listValue, postId: postId)
                postList.accept(deletedPostList)
            }
            .disposed(by: disposeBag)
        
        return Output(postList: postList.asDriver(onErrorJustReturn: []))
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
