//
//  ProfileEventManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/30/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FetchTriggerManager {
    static let shared = FetchTriggerManager()
    let disposeBag = DisposeBag()
    
    let profileFetchTrigger = PublishSubject<Void>()
    let myProfileModel = PublishSubject<ProfileModel>()
    let followTrigger = PublishSubject<Void>()
    
    init() {
        fetchProfileModel()
    }
    
    private func fetchProfileModel() {
        print(#function)
        // profile fetch 요청 시 myProfileModel에 emit
        profileFetchTrigger
            .flatMap { _ in
                return ProfileNetworkManager.shared.fetchMyProfile()
                    .catch { error in
                        print(error)
                        return Single<ProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, profileModel in
                print("FetchTriggerManager - 내 프로필 정보 가져옴")
                owner.myProfileModel.onNext(profileModel)
            }
            .disposed(by: disposeBag)
    }
}
