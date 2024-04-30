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
    var isMyProfile: Bool = true
    var userId = UserDefaultManager.shared.userId
    var isFollowing = false
    
    struct Input {
        let fetchProfileTrigger: PublishSubject<Void>
        let followButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel?>
//        let fetchUserProfileSuccessTrigger: Driver<ProfileModel?>
        let followStatusSuccessTrigger: Driver<FollowStatus?>
        let fetchMeAndUserProfileSuccessTrigger: Driver<([User], ProfileModel?)>
    }
    
    func transform(input: Input) -> Output {
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        let myFollowingList = PublishRelay<[User]>()
        let fetchUserProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        let followStatusSuccessTrigger = PublishRelay<FollowStatus?>()
        
        if !isMyProfile {   // 사용자 프로필 또한 조회
            input.fetchProfileTrigger
                .flatMap { [weak self] in
                    guard let self else { return Single<ProfileModel>.never() }
                    return ProfileNetworkManager.shared.fetchUserProfile(userId: userId)
                        .catch { error in
                            return Single<ProfileModel>.never()
                        }
                }
                .subscribe(with: self) { owner, profileModel in
                    print(profileModel)
                    fetchUserProfileSuccessTrigger.accept(profileModel)
                    owner.profileModel = profileModel
                }
                .disposed(by: disposeBag)
        }
        
        // 내 프로필 조회
        input.fetchProfileTrigger
            .flatMap { [weak self] in
                guard let self else { return Single<ProfileModel>.never() }
                return ProfileNetworkManager.shared.fetchMyProfile()
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profileModel in
                print(profileModel)
                if owner.isMyProfile {
                    fetchMyProfileSuccessTrigger.accept(profileModel)
                    owner.profileModel = profileModel
                } else {
                    myFollowingList.accept(profileModel.following)
                }
            }
            .disposed(by: disposeBag)
        
        let fetchMeAndUserProfileSuccessTrigger = Observable.zip(myFollowingList, fetchUserProfileSuccessTrigger)
        
        
        // 팔로우 또는 팔로우 버튼 취소
        input.followButtonTapped
            .flatMap { [weak self] _ in
                guard let self else { return Single<FollowStatus>.never() }
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
                owner.isFollowing = followStatus.followingStatus
                followStatusSuccessTrigger.accept(followStatus)
            }
            .disposed(by: disposeBag)
        
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorJustReturn: nil),
//                      fetchUserProfileSuccessTrigger: fetchUserProfileSuccessTrigger.asDriver(onErrorJustReturn: nil),
                      followStatusSuccessTrigger: followStatusSuccessTrigger.asDriver(onErrorJustReturn: nil),
                      fetchMeAndUserProfileSuccessTrigger: fetchMeAndUserProfileSuccessTrigger.asDriver(onErrorJustReturn: ([], nil)))
    }
    
    // 유저를 팔로잉하는지 상태 반환
    func setFollowing(myFollowingList: [User], userId: String) {
        print(#function)
        let followingUserIdList = myFollowingList.map { $0.userId }
        if followingUserIdList.contains(userId) {
            isFollowing = true
        } else {
            isFollowing = false
        }
    }
//    
//    // 팔로우 or 언팔로우 시 UserDefaults 팔로잉 정보 수정
//    func setFollowingStatus(status: Bool) {
//        var followingList = UserDefaultManager.shared.following
//        guard let profileModel else { return }  // 유저의 프로필
//        if status { // 팔로잉했을 경우
//            followingList.append(userId)
//        } else {
//            if let index = followingList.firstIndex(of: userId) {
//                followingList.remove(at: index)
//            }
//        }
//        print("following 리스트 수정", followingList)
//        UserDefaultManager.shared.following = followingList
//    }
//    
//    // 내 프로필 가져왔을 때 팔로잉 정보 저장
//    func setFollowing(following: [User]) {
//        let userIdList = following.map { $0.userId }
//        print("나의 following 리스트 저장", userIdList)
//        UserDefaultManager.shared.following = userIdList
//    }
}
