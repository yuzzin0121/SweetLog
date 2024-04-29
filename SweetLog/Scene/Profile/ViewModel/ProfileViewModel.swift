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
    }
    
    struct Output {
        let fetchMyProfileSuccessTrigger: Driver<ProfileModel?>
    }
    
    func transform(input: Input) -> Output {
        let fetchMyProfileSuccessTrigger = PublishRelay<ProfileModel?>()
        
        input.fetchMyProfileTrigger
            .flatMap {
                return ProfileNetworkManager.shared.fetchMyProfile()
                    .catch { error in
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profileModel in
                print(profileModel)
                fetchMyProfileSuccessTrigger.accept(profileModel)
                owner.profileModel = profileModel
                owner.setFollowing(following: profileModel.following)   // 팔로잉 저장
            }
            .disposed(by: disposeBag)
        
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
    
    func setFollowing(following: [User]) {
        let userIdList = following.map { $0.userId }
        UserDefaultManager.shared.following = userIdList
    }
}
