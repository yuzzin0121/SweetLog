//
//  ProfileEventManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileEventManager {
    let shared = ProfileEventManager()
    let disposeBag = DisposeBag()
    
    let profileModel = PublishSubject<ProfileModel>()
    
    init() {
        fetchProfileModel()
    }
    
    private func fetchProfileModel() {
        print(#function)
        profileModel
            .flatMap { _ in
                ProfileNetworkManager.shared.fetchMyProfile()
            }
            .subscribe(with: self) { owner, profileModel in
                owner.profileModel.onNext(profileModel)
            }
            .disposed(by: disposeBag)
    }
}
