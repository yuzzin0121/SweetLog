//
//  ChatRoomViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChatRoomViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let chatRoom: ChatRoom
    private let chatRepository = ChatRepository()
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let chatList: Driver<[Chat]>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let chatListRelay = BehaviorRelay<[Chat]>(value: [])
        let errorString = PublishRelay<String>()
        
        // 소켓을 통해 유저의 채팅을 수신했을 때
        SocketIOManager.shared.receivedUserChat
            .bind(with: self) { owner, receivedUserChat in
                let chatRealm = owner.getChatRealmList(chatList: [receivedUserChat])
                owner.chatRepository.createChatList(chat: chatRealm)
                let chatList = owner.getChatList(roomId: owner.chatRoom.roomId)
                chatListRelay.accept(chatList)
            }
            .disposed(by: disposeBag)
        
        
        // 1. roomId에 해당하는 채팅 리스트 가져오기
        // 2. 채팅 리스트가 존재할 경우
        input.viewDidLoad
            .flatMap { [weak self] _ in
                guard let self else { return Single<Result<ChatListModel,Error>>.never()}
                let roomId = chatRoom.roomId
                let cursorDate = getCursorDate(roomId: chatRoom.roomId)
                return NetworkManager.shared.requestToServer(model: ChatListModel.self, router: ChatRouter.fetchChatHistory(id: roomId, fetchChatHistoryQuery: FetchChatHistoryQuery(cursor_date: cursorDate)))
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let chatListModel):
                    print(chatListModel.data)
                    if !chatListModel.data.isEmpty {
                        let chatRealmList = owner.getChatRealmList(chatList: chatListModel.data)
                        owner.chatRepository.createChatList(chat: chatRealmList)
                    }
                    let chatList = owner.getChatList(roomId: owner.chatRoom.roomId)
                    chatListRelay.accept(chatList)
                    // 소켓 연결
                    SocketIOManager.shared.fetchSocket(roomId: owner.chatRoom.roomId)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(chatList: chatListRelay.asDriver(),
                      errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getChatRealmList(chatList: [Chat]) -> [ChatRealmModel] {
        let chatRealmList = chatList.map {
            let chatRealm = ChatRealmModel(chatId: $0.chatId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, userId: $0.sender.user_id, nickname: $0.sender.nick, profileImage: $0.sender.profileImage)
            $0.files.forEach {
                chatRealm.files.append($0)
            }
            return chatRealm
        }
        return chatRealmList
    }
    
    private func getChatList(roomId: String) -> [Chat] {
        let chatRealmList = chatRepository.fetchChatList(roomId: roomId)
        let chatList = chatRealmList.map {
            Chat(chatId: $0.chatId, roomId: $0.roomId, content: $0.content, createdAt: $0.createdAt, sender: User(user_id: $0.userId, nick: $0.nickname, profileImage: $0.profileImage), files: Array($0.files))
        }
        return chatList
    }
    
    private func getCursorDate(roomId: String) -> String {
        let chatList = chatRepository.fetchChatList(roomId: roomId)
        if let lastChat = chatList.last {
            
            return lastChat.createdAt
        } else {
            return ""   // 존재하는 채팅이 없음
        }
    }
}
