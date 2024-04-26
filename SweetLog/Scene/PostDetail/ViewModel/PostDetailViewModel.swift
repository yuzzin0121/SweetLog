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
        let commentText: Observable<String>
        let commentCreateButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fetchPostItem: Driver<FetchPostItem?>
        let createCommentSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let fetchPostItemRelay = PublishRelay<FetchPostItem?>()
        let commentIsValid = BehaviorRelay(value: false)
        let createCommentSuccessTrigger = PublishRelay<Void>()
        
        // postId를 통해 특정 포스트 조회
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
        
        input.commentText
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                return text
            }
            .subscribe { text in
                guard let text = text.element else { return }
                print(text)
                commentIsValid.accept(text.isEmpty)
            }
            .disposed(by: disposeBag)
        
        input.commentCreateButtonTapped
            .map {
                if !commentIsValid.value {
                    return
                }
            }
            .withLatestFrom(input.commentText)
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                return text
            }
            .flatMap { [weak self] content in
                guard let self, let postId = self.postId else {
                    return Single<Comment>.never()
                }
                print("댓글 생성 고고 \(postId), \(content)")
                return CommentNetworkManager.shared.createComment(postId: postId, contentQuery: ContentQuery(content: content))
                    .catch { error in
                        print(error)
                        return Single<Comment>.never()
                    }
            }
            .subscribe(with: self) { owner, comment in
                owner.fetchPostItem?.comments.append(comment)
                fetchPostItemRelay.accept(owner.fetchPostItem)
                createCommentSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(fetchPostItem: fetchPostItemRelay.asDriver(onErrorJustReturn: nil),
                      createCommentSuccessTrigger: createCommentSuccessTrigger.asDriver(onErrorJustReturn: ()))
    }
}
