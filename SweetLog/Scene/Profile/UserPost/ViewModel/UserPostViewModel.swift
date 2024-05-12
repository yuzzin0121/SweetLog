//
//  UserPostViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserPostViewModel: ViewModelType {
    var postType: PostType?
    var isMyPofile: Bool = true
    var userId: String? // 나 또는 다른 사용자
    var disposeBag = DisposeBag()
    
    struct Input {
        let fetchPostTrigger: Observable<Void>
        let postCellTapped: Observable<FetchPostItem>
    }
    
    struct Output {
        let fetchPostList: Driver<[FetchPostItem]>
        let postCellTapped: Driver<String>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let fetchPostList = PublishRelay<[FetchPostItem]>()
        let postCellTapped = PublishRelay<String>() // postId
        let errorMessage = PublishRelay<String>()
        
        input.fetchPostTrigger
            .flatMap { [weak self] _ in
                guard let self = self, let userId = self.userId else { return  Single<Result<FetchPostModel, Error>>.never() }
                if isMyPofile {    // 내 프로필일 경우
                    if postType == .myPost {
                        return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchUserPost(query: FetchPostQuery(next: nil, limit: "200", product_id: nil, hashTag: nil), userId: userId))
                    } else {    // 좋아요일 경우
                        return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchMyLikePost(query: FetchPostQuery(next: nil, limit: "200", product_id: nil, hashTag: nil)))
                    }
                } else { // 다른 사용자일 경우
                    if postType == .myPost {
                        return NetworkManager.shared.requestToServer(model: FetchPostModel.self, router: PostRouter.fetchUserPost(query: FetchPostQuery(next: nil, limit: "200", product_id: nil, hashTag: nil), userId: userId))
                    } else {
                        return  Single<Result<FetchPostModel, Error>>.never()
                    }
                }
            }
            .bind { result in
                switch result {
                case .success(let fetchPostModel):
                    fetchPostList.accept(fetchPostModel.data)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 포스트 셀 클릭 시
        input.postCellTapped
            .subscribe { fetchPostItem in
                guard let postId = fetchPostItem.element?.postId else { return }
                postCellTapped.accept(postId)
            }
            .disposed(by: disposeBag)
                   
                
        return Output(fetchPostList: fetchPostList.asDriver(onErrorJustReturn: []), 
                      postCellTapped: postCellTapped.asDriver(onErrorJustReturn: ""), 
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
            
    }
}
