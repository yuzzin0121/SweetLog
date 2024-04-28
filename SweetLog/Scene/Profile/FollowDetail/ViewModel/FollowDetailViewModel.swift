//
//  FollowDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var followType: FollowType?
    var users: [User]?
    
    struct Input {
        let userList: Observable<[User]>
    }
    
    struct Output {
        let userList: Driver<[User]>
    }
    
    func transform(input: Input) -> Output {
        
        return Output(userList: input.userList.asDriver(onErrorJustReturn: []))
    }
}
