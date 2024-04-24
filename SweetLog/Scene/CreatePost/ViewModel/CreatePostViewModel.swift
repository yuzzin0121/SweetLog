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
    let contentTextViewPlaceholder = "후기를 작성해주세요"
    var disposeBag = DisposeBag()
    
    struct Input {
        let sugarContent: Observable<Int>
        let reviewText: Observable<String>
        let imageDataList: Observable<[Data]>
        let createPostButtonTapped: Observable<Void>
    }
    
    struct Output {
        let imageDataList: Driver<[Data]>
        let createValid: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let createValid = BehaviorRelay(value: false)
        
        Observable.combineLatest(input.reviewText, input.imageDataList)
            .map {
                let text = $0.0.trimmingCharacters(in: [" "])
                print("내용 \(text.isEmpty), 이미지 \($0.1.isEmpty)")
                return !text.isEmpty && !$0.1.isEmpty
            }
            .subscribe { isValid in
                print(isValid)
                createValid.accept(isValid)
            }
            .disposed(by: disposeBag)
        
        
        input.sugarContent
            .subscribe(with: self) { owner, index in
                print(index)
            }
            .disposed(by: disposeBag)
        
        input.createPostButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                
            }
            
        
        return Output(imageDataList: input.imageDataList.asDriver(onErrorJustReturn: []), createValid: createValid.asDriver(onErrorJustReturn: false))
    }
    
    func getCreateModel() {
        
    }
}
