//
//  PlaceDetailViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/2/24.
//

import Foundation
import RxSwift
import RxCocoa
import LinkPresentation
import MapKit

final class PlaceDetailViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    var postItem: FetchPostItem
    private let metadataProvider = LPMetadataProvider()
    private var metaData: LPLinkMetadata? = nil
    
    init(postItem: FetchPostItem) {
        self.postItem = postItem
    }
    
    struct Input {
        let fetchPlaceTrigger: Observable<Void>
    }
    
    struct Output {
        let placeInfo: Driver<(LPLinkMetadata?, CLLocationCoordinate2D, String, String)>
    }
    
    func transform(input: Input) -> Output {
        let fetchPlaceInfo = BehaviorSubject(value: postItem)
        let placeInfo = PublishRelay<(LPLinkMetadata?, CLLocationCoordinate2D, String, String)>()
        let placeCoordinate = PublishRelay<CLLocationCoordinate2D>()
        
        input.fetchPlaceTrigger
            .subscribe(with: self) { owner, _ in
                let coord = owner.getPlaceCoordinate(xy: owner.postItem.lonlat)
                placeCoordinate.accept(coord)
                owner.getMetaDataFromLink(link: owner.postItem.link) { metaData in
                    owner.metaData = metaData
                    placeInfo.accept((metaData, coord, owner.postItem.placeName, owner.postItem.address))
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(placeInfo: placeInfo.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getPlaceCoordinate(xy: String) -> CLLocationCoordinate2D {
        let xyArray = stringToDoubleArray(string: xy)
        let coord = CLLocationCoordinate2D(latitude: xyArray[1], longitude: xyArray[0])
        return coord
    }
    
    private func stringToDoubleArray(string: String) -> [Double] {
        let trimmedString = string.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
        let stringArray = trimmedString.components(separatedBy: ",")
        let doubleArray = stringArray.compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        return doubleArray
    }
    
    private func getMetaDataFromLink(link: String, completionHandler: @escaping (LPLinkMetadata?) -> Void) {
        print(#function)
        guard let url = URL(string: link) else { return }
        print(url)
        metadataProvider.startFetchingMetadata(for: url) { metadata, error in
            if error != nil {
                print("error")
                return
            }
            guard let metadata else { 
                print("메타 없음")
                return
            }
            completionHandler(metadata)
        }
    }
}
