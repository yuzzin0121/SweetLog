//
//  SignUpViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: - 이메일 중복확인(버튼 클릭), 이메일, 비밀번호, 닉네임 검증, 회원가입
final class SignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let signUpButtonTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
