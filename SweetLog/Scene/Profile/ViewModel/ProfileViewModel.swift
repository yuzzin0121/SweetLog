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
    var profileModel: ProfileModel?
    var isMyProfile: Bool = true
    var userId = UserDefaultManager.shared.userId
    
    struct Input {
        let fetchProfileTrigger: Observable<Void>
        let followButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel?>
        let fetchUserProfileSuccessTrigger: Driver<ProfileModel?>
        let followStatusSuccessTrigger: Driver<FollowStatus?>
    }
    
    func transform(input: Input) -> Output {
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        let fetchUserProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        let followStatusSuccessTrigger = PublishRelay<FollowStatus?>()
        
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
//                print(profileModel)
                fetchMyProfileSuccessTrigger.accept(profileModel)
                if owner.isMyProfile {
                    owner.profileModel = profileModel
                }
                owner.setFollowing(following: profileModel.following)   // 팔로잉 저장
            }
            .disposed(by: disposeBag)
        
        
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
    //                print(profileModel)
                    fetchUserProfileSuccessTrigger.accept(profileModel)
                    owner.profileModel = profileModel
                }
                .disposed(by: disposeBag)
        }
        
        // 팔로우 또는 팔로우 버튼 취소
        input.followButtonTapped
            .flatMap { [weak self] _ in
                guard let self else { return Single<FollowStatus>.never() }
                let isFollowing = self.isFollowing()
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
                followStatusSuccessTrigger.accept(followStatus)
                owner.setFollowingStatus(status: followStatus.followingStatus)
            }
            .disposed(by: disposeBag)
        
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorJustReturn: nil),
                      fetchUserProfileSuccessTrigger: fetchUserProfileSuccessTrigger.asDriver(onErrorJustReturn: nil),
                      followStatusSuccessTrigger: followStatusSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
    
    // 유저를 팔로잉하는지 상태 반환
    func isFollowing() -> Bool {
        guard let profileModel else { return false }
        let followingList = UserDefaultManager.shared.following
        if followingList.contains(profileModel.userId) {
            return true
        } else {
            return false
        }
    }
    
    // 팔로우 or 언팔로우 시 UserDefaults 팔로잉 정보 수정
    func setFollowingStatus(status: Bool) {
        var followingList = UserDefaultManager.shared.following
        guard let profileModel else { return }  // 유저의 프로필
        if status { // 팔로잉했을 경우
            followingList.append(userId)
        } else {
            if let index = followingList.firstIndex(of: userId) {
                followingList.remove(at: index)
            }
        }
        print("following 리스트 저장", followingList)
        UserDefaultManager.shared.following = followingList
    }
    
    // 내 프로필 가져왔을 때 팔로잉 정보 저장
    func setFollowing(following: [User]) {
        let userIdList = following.map { $0.userId }
        print("following 리스트 저장")
        UserDefaultManager.shared.following = userIdList
    }
}
