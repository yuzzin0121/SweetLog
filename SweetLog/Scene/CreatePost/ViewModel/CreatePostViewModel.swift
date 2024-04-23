//
//  CreatePostViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CreatePostViewModel: ViewModelType {
    var placeItem: PlaceItem?
    let filterList = FilterItem.allCases
    var disposeBag = DisposeBag()
    
    struct Input {
        let sugarContent: Observable<Int>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.sugarContent
            .subscribe(with: self) { owner, index in
                print(index)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
