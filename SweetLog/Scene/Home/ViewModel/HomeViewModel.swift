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
    }
    
    struct Output {
        let outputFilterList: Driver<[FilterItem]>
        let outputPostList: Driver<[FetchPostItem]>
    }
    
    func transform(input: Input) -> Output {
        let outputFilterList = PublishRelay<[FilterItem]>()
        let outputPostList = PublishRelay<[FetchPostItem]>()
        
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
                outputPostList.accept(list)
            }
            .disposed(by: disposeBag)
        
        
        return Output(outputFilterList: outputFilterList.asDriver(onErrorJustReturn: []), outputPostList: outputPostList.asDriver(onErrorJustReturn: []))
    }
}
