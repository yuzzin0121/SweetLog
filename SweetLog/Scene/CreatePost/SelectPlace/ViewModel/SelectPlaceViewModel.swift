//
//  SelectPlaceViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectPlaceViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let searchButtonTap: ControlEvent<Void>
        let searchText: ControlProperty<String>
    }
    
    struct Output {
        let placeList: Driver<[PlaceItem]>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let errorString = PublishRelay<String>()
        let placeList = PublishSubject<[PlaceItem]>()
        
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .map {
                let query =  $0.trimmingCharacters(in: [" "])
                return SearchPlaceQuery(query: query)
            }
            .flatMap {
                return KakaoNetworkManager.shared.searchPlace(query: $0)
                    .catch { error in
                        print(error.localizedDescription)
                        errorString.accept(error.localizedDescription)
                        return Single<PlaceModel>.never()
                    }
            }
            .subscribe(with: self) { owner, placeModel in
                placeList.onNext(placeModel.documents)
            }
            .disposed(by: disposeBag)
        
        return Output(placeList: placeList.asDriver(onErrorJustReturn: []), errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
}
