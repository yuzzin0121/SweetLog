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
        let withdrawTapped: Observable<Void>
    }
    
    struct Output {
        let withdrawSuccessTrigger: Driver<Void>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let withdrawSuccessTrigger = PublishRelay<Void>()
        let errorString = PublishRelay<String>()
        
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
        
        return Output(withdrawSuccessTrigger: withdrawSuccessTrigger.asDriver(onErrorJustReturn: ()), errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
    
    func withdraw() {
       
    }
}
