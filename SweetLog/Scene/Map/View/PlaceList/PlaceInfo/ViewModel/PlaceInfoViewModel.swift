//
//  PlaceInfoViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 5/5/24.
//

import Foundation
import RxSwift
import RxCocoa
import LinkPresentation

final class PlaceInfoViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var placeItem: PlaceItem
    private let metadataProvider = LPMetadataProvider()
    
    init(placeItem: PlaceItem) {
        self.placeItem = placeItem
    }
    
    struct Input {
        let placeItem: Observable<PlaceItem>
    }
    
    struct Output {
        let placeItem: Driver<(PlaceItem, LPLinkMetadata)>
    }
    
    func transform(input: Input) -> Output {
        let place = PublishRelay<(PlaceItem, LPLinkMetadata)>()
        
        input.placeItem
            .bind(with: self) { owner, placeItem in
                owner.getMetaDataFromLink(link: placeItem.placeUrl) { meta in
                    guard let meta else { return }
                    place.accept((placeItem, meta))
                }
            }
            .disposed(by: disposeBag)
        
        return Output(placeItem: place.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getMetaDataFromLink(link: String, completionHandler: @escaping (LPLinkMetadata?) -> Void) {
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
