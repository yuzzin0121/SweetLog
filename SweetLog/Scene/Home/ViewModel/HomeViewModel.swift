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
        let filterItemClicked = BehaviorSubject(value: FilterItem.etc)
    }
    
    struct Output {
        let outputFilterList: Driver<[FilterItem]>
        let outputPostList: Driver<[FetchPostItem]>
    }
    
    func transform(input: Input) -> Output {
        let outputFilterList = PublishRelay<[FilterItem]>()
        let outputPostList = PublishRelay<[FetchPostItem]>()
        
        input.viewDidLoad
            .map {
                return FilterItem.allCases
            }
            .subscribe { filterList in
                print("=============\(filterList)")
                outputFilterList.accept(filterList)
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map {
                return FetchPostQuery(next: nil, product_id: nil)
            }
            .flatMap { fetchPostQuery in
                return PostNetworkManager.fetchPosts(fetchPostQuery: fetchPostQuery)
            }
            .subscribe(with: self) { owner, fetchPostModel in
                guard let list = fetchPostModel.data else { return }
                outputPostList.accept(list)
            }
            .disposed(by: disposeBag)
        
        return Output(outputFilterList: outputFilterList.asDriver(onErrorJustReturn: []), outputPostList: outputPostList.asDriver(onErrorJustReturn: []))
    }
}
