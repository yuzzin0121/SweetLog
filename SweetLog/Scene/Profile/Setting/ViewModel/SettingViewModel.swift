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
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
