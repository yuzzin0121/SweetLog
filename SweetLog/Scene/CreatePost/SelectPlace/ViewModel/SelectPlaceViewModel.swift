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
        let searchButtonTap: Observable<Void>
        let searchText: Observable<String>
        let prefetchTrigger: Observable<Void>
    }
    
    struct Output {
        let placeList: Driver<[PlaceItem]>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let errorString = PublishRelay<String>()
        let placeList = BehaviorRelay<[PlaceItem]>(value: [])
        let pageableCount = PublishRelay<Int>()
        let currentPage = BehaviorRelay(value: 1)
        let nextRequest = PublishRelay<Void>()
        
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
                pageableCount.accept(placeModel.meta.pageable_count)
                placeList.accept(placeModel.documents)
            }
            .disposed(by: disposeBag)
        
        input.prefetchTrigger
            .withLatestFrom(pageableCount)
            .bind { pageableCount in
                if currentPage.value < pageableCount {
                    currentPage.accept(currentPage.value + 1)
                    nextRequest.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        nextRequest
            .withLatestFrom(Observable.combineLatest(input.searchText, currentPage))
            .map {
                let query = $0.0.trimmingCharacters(in: [" "])
                return SearchPlaceQuery(query: query, page: $0.1)
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
                var list = placeList.value
                list.append(contentsOf: placeModel.documents)
                placeList.accept(list)
            }
            .disposed(by: disposeBag)
        
        return Output(placeList: placeList.asDriver(onErrorJustReturn: []), errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
}
