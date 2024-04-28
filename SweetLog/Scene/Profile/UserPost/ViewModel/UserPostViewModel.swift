//
//  UserPostViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class UserPostViewModel: ViewModelType {
    var postType: PostType?
    var disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
