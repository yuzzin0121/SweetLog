//
//  EditProfileViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EditProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var currentProfileImageUrl: String?
    var currentNickname: String = ""
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
