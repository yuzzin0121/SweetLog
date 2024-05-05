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
        let centerCoord: Observable<CLLocationCoordinate2D>
        let searchText: Observable<String>
        let searchButtonTapped: Observable<Void>
        let refreshButtonTapped: Observable<Void>
    }
    
    struct Output {
        let viewDidLoadTrigger: Driver<Void>
        let currentLocationButtonTapped: Driver<Void>
        let currentLocationCoord: Driver<CLLocationCoordinate2D>
        let searchText: Driver<String>
        let placeResult: Driver<(String, [PlaceItem])>
        let resultCoord: Driver<CLLocationCoordinate2D>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let viewDidLoadTrigger = PublishRelay<Void>()
        let currentLocationButtonTapped = PublishRelay<Void>()
        let currentLocationCoord = PublishRelay<CLLocationCoordinate2D>()
        let searchText = BehaviorRelay<String>(value: "")
        let placeResult = BehaviorRelay<(String, [PlaceItem])>(value: ("", []))
        let resultCoord = PublishRelay<CLLocationCoordinate2D>()
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
        

        input.refreshButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.searchText, input.centerCoord))
            .map { info in
                let x = String(info.1.longitude)
                let y = String(info.1.latitude)
                let query =  info.0.trimmingCharacters(in: [" "])
                print(SearchPlaceQuery(query: query, x: x, y: y, radius: 15000, sort: "distance"))
                return SearchPlaceQuery(query: query, x: x, y: y, radius: 15000, sort: "distance")
            }
            .flatMap { searchPlaceQuery in
                if searchPlaceQuery.query.count < 2 {
                    return Single<PlaceModel>.never()
                }
                return KakaoNetworkManager.shared.searchPlace(query: searchPlaceQuery)
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
        
        input.searchButtonTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(input.searchText, input.centerCoord))
            .map { info in
                let query =  info.0.trimmingCharacters(in: [" "])
                return SearchPlaceQuery(query: query)
            }
            .flatMap { searchPlaceQuery in
                if searchPlaceQuery.query.count < 2 {
                    return Single<PlaceModel>.never()
                }
                return KakaoNetworkManager.shared.searchPlace(query: searchPlaceQuery)
                    .catch { error in
                        print(error.localizedDescription)
                        errorString.accept(error.localizedDescription)
                        return Single<PlaceModel>.never()
                    }
            }
            .subscribe(with: self) { owner, placeModel in
                placeResult.accept((searchText.value,placeModel.documents))
                guard let firstPlaceItem = placeModel.documents.first else { return }
                guard let coord = owner.getCoordFromXY(x: firstPlaceItem.x, y: firstPlaceItem.y) else { return }
                resultCoord.accept(coord)
            }
            .disposed(by: disposeBag)
        
        
        return Output(viewDidLoadTrigger: viewDidLoadTrigger.asDriver(onErrorJustReturn: ()),
                      currentLocationButtonTapped: currentLocationButtonTapped.asDriver(onErrorJustReturn: ()),
                      currentLocationCoord: currentLocationCoord.asDriver(onErrorDriveWith: .empty()), 
                      searchText: searchText.asDriver(onErrorJustReturn: ""),
                      placeResult: placeResult.asDriver(onErrorJustReturn: ("", [])),
                      resultCoord: resultCoord.asDriver(onErrorDriveWith: .empty()),
                      errorString: errorString.asDriver(onErrorJustReturn: ""))
    }
    
    func getCoordFromXY(x: String, y: String) -> CLLocationCoordinate2D? {
        guard let lat = Double(y), let lon = Double(x) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    func getCoordinate(_ locations: [CLLocation]) -> CLLocationCoordinate2D? {
        if let coordinate = locations.last?.coordinate {
            return coordinate
        }
        return nil
    }
}
