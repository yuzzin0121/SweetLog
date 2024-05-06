//
//  ProfileViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var myProfileModel: ProfileModel?
    var profileModel: ProfileModel?
    var isMyProfile: Bool
    var userId: String
    let fetchMyProfileTrigger = PublishSubject<Void>()
    
    init(isMyProfile: Bool, userId: String) {
        self.isMyProfile = isMyProfile
        self.userId = userId
        NotificationCenter.default.addObserver(self, selector: #selector(fetchMyProfile), name: .fetchMyProfile, object: nil)
    }
    
    struct Input {
        let fetchProfileTrigger: PublishSubject<String>
        let followButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel>
        let isFollowing: Driver<Bool>
        let fetchUserProfileSuccessTrigger: Driver<ProfileModel>
        let followTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        print(#function)
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel>()
        let isFollowing = PublishRelay<Bool>()
        let fetchUserProfileSuccessTrigger = PublishRelay<ProfileModel>()
        let followTrigger = PublishRelay<Void>()
        
        // Notification으로 받았을 때
        fetchMyProfileTrigger
            .flatMap { _ in
                return ProfileNetworkManager.shared.fetchMyProfile()
                    .catch { error in
                        print(error)
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profileModel in
                print("FetchTriggerManager - 내 프로필 정보 가져옴")
                fetchMyProfileSuccessTrigger.accept(profileModel)
                owner.myProfileModel = profileModel
            }
            .disposed(by: disposeBag)
        
        
        input.fetchProfileTrigger
            .flatMap { [weak self] userId in
                guard let self else { return Single<ProfileModel>.never() }
                print("fetchProfileTrigger()")
                if !self.isMyProfile {  // 나의 프로필 화면 아닌 경우 - 유저, 내 프로필 둘 다 조회
                    fetchMyProfileTrigger.onNext(())
                    return ProfileNetworkManager.shared.fetchUserProfile(userId: userId)
                        .catch { error in
                            return Single<ProfileModel>.never()
                        }
                } else {    // 나의 프로필 화면을 경우 - 내 프로필만 조회
                    self.fetchMyProfileTrigger.onNext(())
                    return Single<ProfileModel>.never()
                }
            }
            .subscribe(with: self) { owner, profileModel in
                print("사용자 프로필 조회됨")
                fetchUserProfileSuccessTrigger.accept(profileModel)
                owner.profileModel = profileModel
            }
            .disposed(by: disposeBag)
    
        
        Observable.zip(fetchUserProfileSuccessTrigger, fetchMyProfileSuccessTrigger)
            .subscribe(with: self) { owner, profileModel in
                let (user, me) = profileModel
                let followingStatus = owner.checkFollowing(myFollowingList: me.following, userId: user.userId)
                isFollowing.accept(followingStatus) // 내가 다른 유저를 팔로잉하는지의 여부 emit
            }
            .disposed(by: disposeBag)
   
        // 팔로우 또는 팔로우 버튼 취소
        input.followButtonTapped
            .withLatestFrom(isFollowing)
            .flatMap { isFollowing in
                if !isFollowing { // 팔로잉 상태가 아닌 경우 -> 유저 팔로우
                    return ProfileNetworkManager.shared.followUser(userId: self.userId)
                        .catch { error in
                            return Single<FollowStatus>.never()
                        }
                } else {    // 팔로잉 상태인 경우 -> 유저 언팔로우
                    return ProfileNetworkManager.shared.unfollowUser(userId: self.userId)
                        .catch { error in
                            return Single<FollowStatus>.never()
                        }
                }
            }
            .subscribe(with: self) { owner, followStatus in
                print(followStatus)
                followTrigger.accept(())
//                FetchTriggerManager.shared.followTrigger.onNext(()) // 팔로우 신호 emit
            }
            .disposed(by: disposeBag)
                      
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorDriveWith: .empty()),
                      isFollowing: isFollowing.asDriver(onErrorJustReturn: false),
                      fetchUserProfileSuccessTrigger: fetchUserProfileSuccessTrigger.asDriver(onErrorDriveWith: .empty()), 
                      followTrigger: followTrigger.asDriver(onErrorJustReturn: ()))
    }
    
    
    // 유저를 팔로잉하는지 상태 반환
    func checkFollowing(myFollowingList: [User], userId: String) -> Bool {
        print(#function, myFollowingList, userId)
        let followingIdList = myFollowingList.map { $0.user_id }
        return followingIdList.contains(userId)
    }
    
    @objc func fetchMyProfile() {
        fetchMyProfileTrigger.onNext(())
    }
}
