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
            }
            .disposed(by: disposeBag)
        
        return Output(fetchMyProfileSuccessTrigger: fetchMyProfileSuccessTrigger.asDriver(onErrorJustReturn: nil))
    }
}
