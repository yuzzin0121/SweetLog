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
    let filterList = Observable.just(FilterItem.allCases)
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let filterItemClicked: Observable<Int>
        let postCellTapped: ControlEvent<FetchPostItem>
        let likeObservable: Observable<(Int, Bool)>
    }
    
    struct Output {
        let filterList: Driver<[FilterItem]>
        let postList: Driver<[FetchPostItem]>
        let postCellTapped: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let filterList = PublishRelay<[FilterItem]>()
        let postList = PublishRelay<[FetchPostItem]>()
        let postCellTapped = PublishRelay<String>() // postId
        var postListValue: [FetchPostItem] = []
        var likeIndex: Int?
        
        input.filterItemClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { index in
                return FilterItem(rawValue: index)!
            }
            .map {
                return FetchPostQuery(next: nil, product_id: $0.title)
            }
            .flatMap { fetchPostQuery in
                return PostNetworkManager.shared.fetchPosts(fetchPostQuery: fetchPostQuery)
            }
            .subscribe(with: self) { owner, fetchPostModel in
//                guard let list = fetchPostModel.data else { return }
                let list = fetchPostModel.data
//                print(list)
                postList.accept(list)
                postListValue = list
            }
            .disposed(by: disposeBag)
        
        input.postCellTapped
            .subscribe { fetchPostItem in
                guard let postId = fetchPostItem.element?.postId else { return }
                postCellTapped.accept(postId)
            }
            .disposed(by: disposeBag)
        
        input.likeObservable
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { value in
                let postItem = postListValue[value.0]
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
