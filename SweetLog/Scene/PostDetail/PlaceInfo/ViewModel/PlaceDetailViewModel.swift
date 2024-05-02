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
        let fetchPlaceInfo: Driver<FetchPostItem>
        let linkMetaData: Driver<LPLinkMetadata?>
    }
    
    func transform(input: Input) -> Output {
        let fetchPlaceInfo = BehaviorSubject(value: postItem)
        let linkMetaData = PublishRelay<LPLinkMetadata?>()
        
        input.fetchPlaceTrigger
            .subscribe(with: self) { owner, _ in
                print(owner.postItem.link)
                owner.getMetaDataFromLink(link: owner.postItem.link) { metaData in
                    owner.metaData = metaData
                    linkMetaData.accept(metaData)
                }
            }
            .disposed(by: disposeBag)
        
        
        return Output(fetchPlaceInfo: fetchPlaceInfo.asDriver(onErrorDriveWith: .empty()), 
                      linkMetaData: linkMetaData.asDriver(onErrorJustReturn: nil))
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
