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
    let contentTextViewPlaceholder = "리뷰를 작성해주세요"
    var disposeBag = DisposeBag()
    
    struct Input {
        let sugarContent: Observable<Int>
        let reviewText: Observable<String>
        let imageDataList: Observable<[Data]>
    }
    
    struct Output {
        let imageDataList: Driver<[Data]>
    }
    
    func transform(input: Input) -> Output {
        input.sugarContent
            .subscribe(with: self) { owner, index in
                print(index)
            }
            .disposed(by: disposeBag)
        
        return Output(imageDataList: input.imageDataList.asDriver(onErrorJustReturn: []))
    }
}
