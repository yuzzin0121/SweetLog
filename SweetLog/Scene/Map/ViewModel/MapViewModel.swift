//
//  MapViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import Foundation
import RxCocoa
import RxSwift
import CoreLocation

final class MapViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let currentLocationButtonTapped: Observable<Void>
        let getCurrentLocations: Observable<[CLLocation]>
        let searchText: Observable<String>
        let searchButtonTapped: Observable<Void>
    }
    
    struct Output {
        let viewDidLoadTrigger: Driver<Void>
        let currentLocationButtonTapped: Driver<Void>
        let currentLocationCoord: Driver<CLLocationCoordinate2D>
        let searchText: Driver<String>
        let placeResult: Driver<(String, [PlaceItem])>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let viewDidLoadTrigger = PublishRelay<Void>()
        let currentLocationButtonTapped = PublishRelay<Void>()
        let currentLocationCoord = PublishRelay<CLLocationCoordinate2D>()
        let searchText = BehaviorRelay<String>(value: "")
        let placeResult = BehaviorRelay<(String, [PlaceItem])>(value: ("", []))
        let errorString = PublishRelay<String>()
        
        input.viewDidLoadTrigger
            .bind { _ in
                viewDidLoadTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        // 현재 위치 버튼 클릭했을 때
        input.currentLocationButtonTapped
            .bind { _ in
                currentLocationButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
        
        input.getCurrentLocations
            .bind(with: self) { owner, locations in
                guard let currentCoord = owner.getCoordinate(locations) else { return }
                currentLocationCoord.accept(currentCoord)
            }
            .disposed(by: disposeBag)
        
        input.searchText
            .bind(with: self) { owner, text in
                searchText.accept(text)
            }
            .disposed(by: disposeBag)
        
        input.searchButtonTapped
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
                placeResult.accept((searchText.value,placeModel.documents))
            }
            .disposed(by: disposeBag)
        
        return Output(viewDidLoadTrigger: viewDidLoadTrigger.asDriver(onErrorJustReturn: ()),
                      currentLocationButtonTapped: currentLocationButtonTapped.asDriver(onErrorJustReturn: ()),
                      currentLocationCoord: currentLocationCoord.asDriver(onErrorDriveWith: .empty()), 
                      searchText: searchText.asDriver(onErrorJustReturn: ""),
                      placeResult: placeResult.asDriver(onErrorJustReturn: ("", [])),
                      errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
    
    func getCoordinate(_ locations: [CLLocation]) -> CLLocationCoordinate2D? {
        if let coordinate = locations.last?.coordinate {
            return coordinate
        }
        return nil
    }
}
