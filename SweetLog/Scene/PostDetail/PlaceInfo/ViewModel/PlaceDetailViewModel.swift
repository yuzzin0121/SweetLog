//
//  PlaceDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PlaceDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var postItem: FetchPostItem
    
    init(postItem: FetchPostItem) {
        self.postItem = postItem
    }
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
}
