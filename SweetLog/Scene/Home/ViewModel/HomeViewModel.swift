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
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let outputPostList: Driver<[FetchPostItem]>
    }
    
    func transform(input: Input) -> Output {
        let outputPostList = PublishRelay<[FetchPostItem]>()
        
        input.viewDidLoad
            .map {
                return FetchPostQuery(next: nil, limit: nil, product_id: "냠냠이")
            }
            .flatMap { fetchPostQuery in
                return PostNetworkManager.fetchPosts(fetchPostQuery: fetchPostQuery)
            }
            .subscribe(with: self) { owner, fetchPostModel in
                print(fetchPostModel)
                guard let list = fetchPostModel.data else { return }
                outputPostList.accept(list)
            }
            .disposed(by: disposeBag)
        
        return Output(outputPostList: outputPostList.asDriver(onErrorJustReturn: []))
    }
}
