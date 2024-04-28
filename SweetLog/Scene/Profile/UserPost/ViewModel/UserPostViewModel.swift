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
    }
    
    struct Output {
        let fetchPostList: Driver<[FetchPostItem]>
    }
    
    func transform(input: Input) -> Output {
        let fetchPostList = PublishRelay<[FetchPostItem]>()
        input.fetchPostTrigger
            .flatMap { [weak self] _ in
                print("음낭ㄹ머ㅏㄴㅇ로민ㅇ루민ㅇㄹㅁ니ㅏ얾너알;문ㅇㄹ")
                guard let self = self, let userId = self.userId else { return  Single<FetchPostModel>.never() }
                print("UserPostViewModel: \(userId), postType: \(postType), isMyProfile: \(isMyPofile)")
                if isMyPofile {    // 내 프로필일 경우
                    if postType == .myPost {
                        return PostNetworkManager.shared.fetchUserPosts(fetchPostQuery: FetchPostQuery(next: nil, limit: "200", product_id: nil), userId: userId)
                            .catch { error in
                                print(error.localizedDescription)
                                return  Single<FetchPostModel>.never()
                            }
                    } else {    // 좋아요일 경우
                        return PostNetworkManager.shared.fetchMyLikePost(fetchPostQuery: FetchPostQuery(next: nil, limit: "200", product_id: nil))
                            .catch { error in
                                return  Single<FetchPostModel>.never()
                            }
                    }
                } else { // 다른 사용자일 경우
                    if postType == .myPost {
                        return PostNetworkManager.shared.fetchUserPosts(fetchPostQuery: FetchPostQuery(next: nil, limit: "200", product_id: nil), userId: userId)
                            .catch { error in
                                return  Single<FetchPostModel>.never()
                            }
                    }
                }
                return Single<FetchPostModel>.never()
            }
            .subscribe(with: self) { owner, fetchPostModel in
                print(fetchPostModel)
                fetchPostList.accept(fetchPostModel.data)
            }
            .disposed(by: disposeBag)
                   
                
        return Output(fetchPostList: fetchPostList.asDriver(onErrorJustReturn: []))
            
    }
}
