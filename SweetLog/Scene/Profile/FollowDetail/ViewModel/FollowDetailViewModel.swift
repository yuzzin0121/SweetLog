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
    var users: [User]
    var currentUser: User?
    
    init(followType: FollowType, isMyProfile: Bool, users: [User]) {
        self.followType = followType
        self.isMyProfile = isMyProfile
        self.users = users
    }
    
    struct Input {
        let fetchUserList: PublishSubject<Void>
        let followButtonTapped: Observable<User>  // 유저 아이디
    }
    
    struct Output {
        let userList: Driver<[User]>
    }
    
    func transform(input: Input) -> Output {
        print(#function)
        let fetchUserList = PublishRelay<[User]>()
        
        FetchTriggerManager.shared.myProfileModel
            .subscribe(with: self) { owner, myProfile in
                print("FollowDetailViewModel - 내 프로필 저장")
                owner.myProfile = myProfile
            }
            .disposed(by: disposeBag)
        
        input.fetchUserList
            .subscribe(with: self) { owner, _ in
                print("fetchUserList - \(owner.users)")
                fetchUserList.accept(owner.users)
            }
            .disposed(by: disposeBag)
        
        
        // 팔로우 버튼 클릭 시
        input.followButtonTapped
            .flatMap { [weak self] user in
                guard let self else { return Single<FollowStatus>.never() }
                self.currentUser = user
                
                let isFollowing = self.isFollowingUser(userId: user.user_id)
                if !isFollowing { // 팔로잉 상태가 아닌 경우 -> 유저 팔로우
                    return ProfileNetworkManager.shared.followUser(userId: user.user_id)
                        .catch { error in
                            return Single<FollowStatus>.never()
                        }
                } else {    // 팔로잉 상태인 경우 -> 유저 언팔로우
                    return ProfileNetworkManager.shared.unfollowUser(userId: user.user_id)
                        .catch { error in
                            return Single<FollowStatus>.never()
                        }
                }
            }
            .subscribe(with: self) { owner, followStatus in
                print(followStatus)
                guard let user = owner.currentUser else { return }
                owner.setUserList(followStatus: followStatus.followingStatus, user: user)
                fetchUserList.accept(owner.users)
            }
            .disposed(by: disposeBag)
        
        return Output(userList: fetchUserList.asDriver(onErrorJustReturn: []))
    }
    
    private func setUserList(followStatus: Bool, user: User) {
        guard var myProfile else { return }
        if followStatus {   // 팔로우 성공 시
            myProfile.following.append(User(user_id: user.user_id,
                                            nick: user.nick,
                                            profileImage: user.profileImage))
        } else {
            if let index = myProfile.following.firstIndex(where: { $0.user_id == user.user_id }) {
                myProfile.following.remove(at: index)
            }
        }
    }
    
    private func isFollowingUser(userId: String) -> Bool {
        guard let myProfile else { return false }
        let followingUserIdList = myProfile.following.map { $0.user_id }
        return followingUserIdList.contains(userId)
    }
}
