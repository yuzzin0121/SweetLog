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
    var myProfileModel: ProfileModel?
    
    struct Input {
        let postId: Observable<String>
        let commentText: Observable<String>
        let commentCreateButtonTapped: Observable<Void>
        let likeButtonStatus: Observable<Bool>
        let commentMoreItemClicked: Observable<(Int, Int, String)>
        let postMoreItemClicked: Observable<(Int)>
        let placeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fetchPostItem: Driver<FetchPostItem?>
        let createCommentSuccessTrigger: Driver<Void>
        let deleteSuccessTrigger: Driver<String>
        let placeButtonTapped: Driver<FetchPostItem>
        let editPostTrigger: Driver<(PlaceItem, FetchPostItem)>
    }
    
    func transform(input: Input) -> Output {
        let fetchPostItemRelay = PublishRelay<FetchPostItem?>()
        let commentIsValid = BehaviorRelay(value: false)
        let createCommentSuccessTrigger = PublishRelay<Void>()
        
        let deletePostTrigger = PublishSubject<String>()
        let deletePostSuccessTrigger = PublishRelay<String>()
        let deleteCommentTrigger = PublishSubject<(String, String)>()
        let placeButtonTapped = PublishRelay<FetchPostItem>()
        let editPostTrigger = PublishRelay<(PlaceItem, FetchPostItem)>()
        
        // postId를 통해 특정 포스트 조회
        input.postId
            .flatMap {
                return PostNetworkManager.shared.fetchPost(postId: $0)
                        .catch { error in
                            return Single<FetchPostItem>.never()
                        }
            }
            .subscribe(with: self) { owner, fetchPostItem in
                owner.fetchPostItem = fetchPostItem
                fetchPostItemRelay.accept(fetchPostItem)
            }
            .disposed(by: disposeBag)
        
        input.placeButtonTapped
            .withLatestFrom(fetchPostItemRelay)
            .subscribe(with: self) { owner, postItem in
                guard let postItem else { return }
                placeButtonTapped.accept(postItem)
            }
            .disposed(by: disposeBag)
        
        // 댓글 타이핑할 때
        input.commentText
            .map {
                let text = $0.trimmingCharacters(in: [" "])
                return text
            }
            .subscribe { text in
                guard let text = text.element else { return }
                commentIsValid.accept(text.isEmpty)
            }
            .disposed(by: disposeBag)
        
        // 댓글 작성 클릭
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
                return CommentNetworkManager.shared.createComment(postId: postId, contentQuery: ContentQuery(content: content))
                    .catch { error in
                        print(error)
                        return Single<Comment>.never()
                    }
            }
            .subscribe(with: self) { owner, comment in
                owner.fetchPostItem?.comments.insert(comment, at: 0)
                fetchPostItemRelay.accept(owner.fetchPostItem)
                createCommentSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 좋아요 상태 변경됐을 때
        input.likeButtonStatus
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                LikeStatusModel(likeStatus: $0)
            }
            .flatMap {
                guard let postId = self.postId else {
                    return Single<LikeStatusModel>.never()
                }
                print(postId)
                return PostNetworkManager.shared.likePost(postId: postId, likeStatusModel: $0)
                    .catch { error in
                        print(error.localizedDescription)
                        return Single<LikeStatusModel>.never()
                    }
            }
            .subscribe(with: self) { owner, likeStatusModel in
                guard var fetchPostItem = owner.fetchPostItem else { return }
                let likeStatus = likeStatusModel.likeStatus
                if likeStatus == true {
                    fetchPostItem.likes.append(UserDefaultManager.shared.userId)
                } else {
                    if let index = fetchPostItem.likes.firstIndex(where: { $0 == UserDefaultManager.shared.userId }) {
                        fetchPostItem.likes.remove(at: index)
                    }
                }
                owner.fetchPostItem = fetchPostItem
                fetchPostItemRelay.accept(fetchPostItem)
            }
            .disposed(by: disposeBag)
        
        // 포스트 더보기에서 아이템 클릭 시
        input.postMoreItemClicked
            .subscribe(with: self) { owner, moreItemIndex in
                guard let moreItem = MoreItem(rawValue: moreItemIndex), let fetchPostItem = owner.fetchPostItem else { return }
                switch moreItem {
                case .edit:
                    let placeItem = owner.getPlaceItem(postItem: fetchPostItem)
                    editPostTrigger.accept((placeItem, fetchPostItem))
                case .delete:
                    deletePostTrigger.onNext(fetchPostItem.postId)
                }
            }
            .disposed(by: disposeBag)
        
        // 포스트 삭제
        deletePostTrigger
            .flatMap { postId in
                return PostNetworkManager.shared.deletePost(postId: postId)
                    .catch { error in
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, postId in
                deletePostSuccessTrigger.accept(postId)
            }
            .disposed(by: disposeBag)
        
        // 댓글의 더보기에서 수정 또는 삭제 클릭했을 때
        input.commentMoreItemClicked
            .subscribe(with: self) { owner, clickInfo in
                print(clickInfo)
                let (moreItemIndex, index, commentId) = clickInfo
                guard let moreItem = MoreItem(rawValue: moreItemIndex), let fetchPostItem = owner.fetchPostItem else  { return }
                switch moreItem {
                case .edit: // 댓글 수정 클릭했을 때
                    return
                case .delete: // 댓글 삭제 클릭했을 때
                    let postId = fetchPostItem.postId
                    deleteCommentTrigger.onNext((postId, commentId))
                    return
                }
            }
            .disposed(by: disposeBag)
        
        // 댓글 삭제
        deleteCommentTrigger
            .flatMap {  deleteInfo in
                return CommentNetworkManager.shared.deleteComment(postId: deleteInfo.0, commentId: deleteInfo.1)
                    .catch { error in
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, commentId in
                let postItem = owner.deleteComment(commentId: commentId)
                fetchPostItemRelay.accept(postItem)
            }
            .disposed(by: disposeBag)
        
        return Output(fetchPostItem: fetchPostItemRelay.asDriver(onErrorJustReturn: nil),
                      createCommentSuccessTrigger: createCommentSuccessTrigger.asDriver(onErrorJustReturn: ()), 
                      deleteSuccessTrigger: deletePostSuccessTrigger.asDriver(onErrorJustReturn: ""), 
                      placeButtonTapped: placeButtonTapped.asDriver(onErrorDriveWith: .empty()),
                      editPostTrigger: editPostTrigger.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getPlaceItem(postItem: FetchPostItem) -> PlaceItem {
        let xyArray = stringToDoubleArray(string: postItem.lonlat)
        let placeItem = PlaceItem(address: postItem.address, placeName: postItem.placeName, placeUrl: postItem.link, x: xyArray[1], y: xyArray[0])
        return placeItem
    }
    
    private func stringToDoubleArray(string: String) -> [String] {
        let trimmedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        let stringArray = trimmedString.components(separatedBy: ",")
        return stringArray
    }
    
    private func deleteComment(commentId: String) -> FetchPostItem? {
        guard var fetchPostItem else { return nil }
        if let index = fetchPostItem.comments.firstIndex(where: { $0.commentId == commentId }) {
            fetchPostItem.comments.remove(at: index)
        }
        self.fetchPostItem = fetchPostItem
        return fetchPostItem
    }
    
    func checkIsMe() -> Bool {
        guard let fetchPostItem else {
            print("모델 없음")
            return false
        }
        return fetchPostItem.creator.userId == UserDefaultManager.shared.userId
    }
}
