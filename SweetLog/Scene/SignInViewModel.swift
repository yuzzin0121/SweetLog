//
//  SignInViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import Foundation
import RxSwift
import RxCocoa

// TODO: - 회원가입버튼 클릭, 이메일, 비밀번호 로그인
final class SignInViewModel: ViewModelType {
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
