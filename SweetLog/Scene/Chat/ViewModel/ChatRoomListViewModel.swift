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
        let chatRoomTapped: Observable<ChatRoom>
    }
    
    struct Output {
        let chatRoomList: Driver<[ChatRoom]>
        let chatRoomTapped: Driver<ChatRoom>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let chatRoomList = BehaviorRelay<[ChatRoom]>(value: [])
        let chatRoomTapped = PublishRelay<ChatRoom>()
        let errorString = PublishRelay<String>()
        
        input.viewDidLoad
            .flatMap { _ in
                NetworkManager.shared.requestToServer(model: ChatRoomListModel.self, router: ChatRouter.fetchChatroomList)
            }
            .bind { result in
                switch result {
                case .success(let chatRoomListModel):
                    chatRoomList.accept(chatRoomListModel.data)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        input.chatRoomTapped
            .bind { chatRoom in
                chatRoomTapped.accept(chatRoom)
            }
            .disposed(by: disposeBag)
        
        return Output(chatRoomList: chatRoomList.asDriver(), 
                      chatRoomTapped: chatRoomTapped.asDriver(onErrorDriveWith: .empty()),
                      errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
}
