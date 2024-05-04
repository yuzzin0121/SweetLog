//
//  PlaceListViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PlaceListViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var placeList = PublishRelay<[PlaceItem]>()
    var searchText = PublishRelay<String>()
    
    struct Input {
        
    }
    
    struct Output {
        let searchText: Driver<String>
        let placeList: Driver<[PlaceItem]>
    }
    
    func transform(input: Input) -> Output {
        
     
        
        return Output(searchText: searchText.asDriver(onErrorJustReturn: ""),
                      placeList: placeList.asDriver(onErrorJustReturn: []))
    }
}
