//
//  PostDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/25/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var postId: String?
    var fetchPostItem: FetchPostItem?
    
    struct Input {
        let postId: Observable<String>
    }
    
    struct Output {
        let fetchPostItem: Driver<FetchPostItem?>
    }
    
    func transform(input: Input) -> Output {
        let fetchPostItemRelay = PublishRelay<FetchPostItem?>()
        
        input.postId
            .flatMap {
                return PostNetworkManager.shared.fetchPost(postId: $0)
                        .catch { error in
                            return Single<FetchPostItem>.never()
                        }
            }
            .subscribe(with: self) { owner, fetchPostItem in
                print(fetchPostItem)
                fetchPostItemRelay.accept(fetchPostItem)
                owner.fetchPostItem = fetchPostItem
            }
            .disposed(by: disposeBag)
        
        return Output(fetchPostItem: fetchPostItemRelay.asDriver(onErrorJustReturn: nil))
    }
}
