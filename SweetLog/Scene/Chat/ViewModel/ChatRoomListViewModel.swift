//
//  ChatRoomListViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatRoomListViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let chatRoomList: Driver<[ChatRoom]>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let chatRoomList = BehaviorRelay<[ChatRoom]>(value: [])
        let errorString = PublishRelay<String>()
        
        input.viewDidLoad
            .flatMap { _ in
                NetworkManager.shared.requestToServer(model: ChatRoomListModel.self, router: ChatRouter.fetchChatroomList)
            }
            .bind { result in
                switch result {
                case .success(let chatRoomListModel):
                    print(chatRoomListModel)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(chatRoomList: chatRoomList.asDriver(), errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
}
