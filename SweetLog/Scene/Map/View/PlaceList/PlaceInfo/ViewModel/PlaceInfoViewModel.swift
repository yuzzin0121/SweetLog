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
import RxDataSources

struct PlaceInfoSection {
    var header: PlaceItem
    var meta: LPLinkMetadata
    var items: [FetchPostItem]
}

extension PlaceInfoSection: SectionModelType {
    typealias Item = FetchPostItem
        
    init(original: PlaceInfoSection, items: [FetchPostItem]) {
        self = original
        self.items = items
    }
}

final class PlaceInfoViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var placeItem: PlaceItem
    private let metadataProvider = LPMetadataProvider()
    
    init(placeItem: PlaceItem) {
        self.placeItem = placeItem
    }
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let placeItem: Observable<PlaceItem>
    }
    
    struct Output {
        let placeItem: Driver<(PlaceItem, LPLinkMetadata)>
        let postList: Driver<[FetchPostItem]>
        let placeInfoSection: PublishSubject<[PlaceInfoSection]>
    }
    
    func transform(input: Input) -> Output {
        let place = PublishRelay<(PlaceItem, LPLinkMetadata)>()
        let postList = PublishRelay<[FetchPostItem]>()
        let next = BehaviorSubject(value: "")
        let placeInfoSection = PublishSubject<[PlaceInfoSection]>()
        
        input.viewDidLoadTrigger
            .withLatestFrom(input.placeItem)
            .map { placeItem in
                let seatchText = String.getFirstWord(fullText: placeItem.placeName)
                let query = FetchPostQuery(next: nil, limit: "20", product_id: nil, hashTag: seatchText)
                return query
            }
            .flatMap {
                return PostNetworkManager.shared.searchTagPosts(fetchPostQuery: $0)
                    .catch { error in
                        return Single<FetchPostModel>.never()
                    }
            }
            .subscribe(with: self) { owner, fetchPostModel in
                print("검색된 포스트 개수 \(fetchPostModel.data.count)")
                next.onNext(fetchPostModel.nextCursor)
                postList.accept(fetchPostModel.data)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(place, postList)
            .map { value in
                print("dmdkdkdkdkdkdkdkdkdkdkaksdfjlkasdbfljasbd")
                print(PlaceInfoSection(header: value.0.0, meta: value.0.1, items: value.1))
                return [PlaceInfoSection(header: value.0.0, meta: value.0.1, items: value.1)]
            }
            .bind { placeInfoSectionValue in
                placeInfoSection.onNext(placeInfoSectionValue)
            }
            .disposed(by: disposeBag)
        
        input.placeItem
            .bind(with: self) { owner, placeItem in
                owner.getMetaDataFromLink(link: placeItem.placeUrl) { meta in
                    guard let meta else { return }
                    place.accept((placeItem, meta))
                }
            }
            .disposed(by: disposeBag)
        
        
        
        return Output(placeItem: place.asDriver(onErrorDriveWith: .empty()), 
                      postList: postList.asDriver(onErrorJustReturn: []), 
                      placeInfoSection: placeInfoSection)
    }
    
    private func getMetaDataFromLink(link: String, completionHandler: @escaping (LPLinkMetadata?) -> Void) {
        guard let url = URL(string: link) else { return }
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
