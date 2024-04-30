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
        let fetchMyProfileTrigger: Observable<Void>
        let followButtonTapped: Observable<Bool>
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel?>
        let followStatusSuccessTrigger: Driver<FollowStatus?>
    }
    
    func transform(input: Input) -> Output {
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        let followStatusSuccessTrigger = PublishRelay<FollowStatus?>()
        
        input.fetchMyProfileTrigger
            .flatMap { [weak self] in
                guard let self else { return Single<ProfileModel>.never() }
                if isMyProfile {
                    return ProfileNetworkManager.shared.fetchMyProfile()
                        .catch { error in
                            return Single<ProfileModel>.never()
                        }
                } else {
                    return ProfileNetworkManager.shared.fetchUserProfile(userId: userId)
                        .catch { error in
                            return Single<ProfileModel>.never()
                        }
                }
            }
            .subscribe(with: self) { owner, profileModel in
//                print(profileModel)
                fetchMyProfileSuccessTrigger.accept(profileModel)
                owner.profileModel = profileModel
                owner.setFollowing(following: profileModel.following)   // 팔로잉 저장
            }
            .disposed(by: disposeBag)
        
        // 팔로우 또는 팔로우 버튼 취소
        input.followButtonTapped
            .flatMap { [weak self] isFollowing in
                guard let self else { return Single<FollowStatus>.never() }
                print("팔로우 버튼 클릭 \(isFollowing)")
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
                      followStatusSuccessTrigger: followStatusSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
    
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
        print("following 리스트 저장")
        UserDefaultManager.shared.following = followingList
    }
    
    func setFollowing(following: [User]) {
        let userIdList = following.map { $0.userId }
        print("following 리스트 저장")
        UserDefaultManager.shared.following = userIdList
    }
}
