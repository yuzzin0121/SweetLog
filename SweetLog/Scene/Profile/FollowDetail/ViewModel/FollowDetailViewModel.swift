//
//  FollowDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var followType: FollowType
    var isMyProfile: Bool
    var myProfile: ProfileModel?
    var userId: String
    var currentUser: User?
    
    init(followType: FollowType, isMyProfile: Bool, userId: String) {
        self.followType = followType
        self.isMyProfile = isMyProfile
        self.userId = userId
    }
    
    struct Input {
        let fetchMyProfileTrigger: Observable<Void>
        let fetchUserList: PublishSubject<Void>
        let followButtonTapped: Observable<User>  // 유저 아이디
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel>
        let userList: Driver<[User]>
        let userFollow: Driver<Void>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        print(#function)
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel>()
        let fetchUserList = PublishRelay<[User]>()
        let userFollow = PublishRelay<Void>()
        let errorMessage = PublishRelay<String>()

        // Notification으로 받았을 때
        input.fetchMyProfileTrigger
            .flatMap { _ in
                return NetworkManager.shared.requestToServer(model: ProfileModel.self, router: ProfileRouter.fetchMyProfile)
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let profileModel):
                    fetchMyProfileSuccessTrigger.accept(profileModel)
                    owner.myProfile = profileModel
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.fetchUserList
            .flatMap { [weak self] in
                guard let self else { return Single<Result<ProfileModel, Error>>.never() }
                return NetworkManager.shared.requestToServer(model: ProfileModel.self, router: ProfileRouter.fetchUserProfile(userId: userId))
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let profileModel):
                    let userList = owner.followType == .follow ? profileModel.followers : profileModel.following
                    fetchUserList.accept(userList)
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        
        // 팔로우 버튼 클릭 시
        input.followButtonTapped
            .flatMap { [weak self] user in
                guard let self else { return Single<Result<FollowStatus, Error>>.never() }
                self.currentUser = user
                
                let isFollowing = self.isFollowingUser(userId: user.user_id)
                if !isFollowing { // 팔로잉 상태가 아닌 경우 -> 유저 팔로우
                    return NetworkManager.shared.requestToServer(model: FollowStatus.self, router: ProfileRouter.follow(userId: user.user_id))
                } else {    // 팔로잉 상태인 경우 -> 유저 언팔로우
                    return NetworkManager.shared.requestToServer(model: FollowStatus.self, router: ProfileRouter.unfollow(userId: user.user_id))
                }
            }
            .subscribe(with: self) { owner, result in
                switch result {
                case .success(let followStatus):
                    print(followStatus)
                    guard let user = owner.currentUser else { return }
                    userFollow.accept(())
                case .failure(let error):
                    errorMessage.accept(error.localizedDescription)
                }
                
            }
            .disposed(by: disposeBag)
        
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorDriveWith: .empty()), 
                      userList: fetchUserList.asDriver(onErrorJustReturn: []),
                      userFollow: userFollow.asDriver(onErrorJustReturn: ()),
                      errorMessage: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    private func isFollowingUser(userId: String) -> Bool {
        guard let myProfile else { return false }
        let followingUserIdList = myProfile.following.map { $0.user_id }
        return followingUserIdList.contains(userId)
    }
}
