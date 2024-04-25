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
        
        input.filterItemClicked
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map { index in
                print(index)
                return FilterItem(rawValue: index)!
            }
            .map {
                print($0.title)
                return FetchPostQuery(next: nil, product_id: $0.title)
            }
            .flatMap { fetchPostQuery in
                return PostNetworkManager.shared.fetchPosts(fetchPostQuery: fetchPostQuery)
            }
            .subscribe(with: self) { owner, fetchPostModel in
                guard let list = fetchPostModel.data else { return }
                print(list)
                postList.accept(list)
            }
            .disposed(by: disposeBag)
        
        input.postCellTapped
            .subscribe { fetchPostItem in
                guard let postId = fetchPostItem.element?.postId else { return }
                postCellTapped.accept(postId)
            }
            .disposed(by: disposeBag)
        
        return Output(filterList: filterList.asDriver(onErrorJustReturn: []),
                      postList: postList.asDriver(onErrorJustReturn: []),
                      postCellTapped: postCellTapped.asDriver(onErrorJustReturn: ""))
    }
}
