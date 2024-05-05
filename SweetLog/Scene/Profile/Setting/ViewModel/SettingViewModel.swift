//
//  SettingViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingViewModel {
    var disposeBag = DisposeBag()
    let settingItemList = Observable.just(SettingItem.allCases)
    
    struct Input {
        let logoutTapped: Observable<Void>
        let withdrawTapped: Observable<Void>
    }
    
    struct Output {
        let logoutSuccessTrigger: Driver<Void>
        let withdrawSuccessTrigger: Driver<Void>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let logoutSuccessTrigger = PublishRelay<Void>()
        let withdrawSuccessTrigger = PublishRelay<Void>()
        let errorString = PublishRelay<String>()
        
        input.logoutTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.logout()
                logoutSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.withdrawTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap {
                AuthNetworkManager.shared.withdraw()
                    .catch { error in
                        errorString.accept(error.localizedDescription)
                        return Single<JoinModel>.never()
                    }
            }
            .subscribe(with: self) { owner, joinModel in
                print(joinModel)
                withdrawSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(logoutSuccessTrigger: logoutSuccessTrigger.asDriver(onErrorJustReturn: ()),
                      withdrawSuccessTrigger: withdrawSuccessTrigger.asDriver(onErrorJustReturn: ()),
                      errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
    
    private func logout() {
        UserDefaultManager.shared.ud.removeObject(forKey: UserDefaultManager.UDKey.userId.rawValue)
        UserDefaultManager.shared.ud.removeObject(forKey: UserDefaultManager.UDKey.accessToken.rawValue)
        UserDefaultManager.shared.ud.removeObject(forKey: UserDefaultManager.UDKey.refreshToken.rawValue)
    }
    
    func withdraw() {
       
    }
}
