//
//  ChatRoomViewModel.swift
//  SweetLog
//
//  Created by 조유진 on 7/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

final class ChatRoomViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let chatRoom: ChatRoom
    private let chatRepository = ChatRepository()
    
    init(chatRoom: ChatRoom) {
        self.chatRoom = chatRoom
    }
    
    deinit {
        SocketIOManager.shared.leaveConnection()
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let sendButtonTapped: Observable<Void>
        let sendContent: Observable<String>
    }
    
    struct Output {
        let sectionChatDataList: PublishSubject<[SectionOfChat]>
        let sendButtonTapped: Driver<Void>
        let sendContentSuccess: Driver<Void>
        let userNick: Driver<String>
        let errorString: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let sectionChatDataListSubject = PublishSubject<[SectionOfChat]>()
        let sendButtonTapped = PublishRelay<Void>()
        let sendContentSuccess = PublishRelay<Void>()
        let userNickRelay = PublishRelay<String>()
        let errorString = PublishRelay<String>()
        
        // 소켓을 통해 유저의 채팅을 수신했을 때
        SocketIOManager.shared.receivedUserChat
            .bind(with: self) { owner, receivedUserChat in
                // Chat을 ChatRealmModel로 변환
                let chatRealm = owner.getChatRealmList(chatList: [receivedUserChat])
                owner.chatRepository.createChatList(chat: chatRealm)    // Realm에 수신한 채팅 저장
                let chatList = owner.getChatList(roomId: owner.chatRoom.roomId) // roomId에 해당하는 채팅내역 조회
                let sectionOfChatList = owner.setSectionChatData(chatList: chatList)
                sectionChatDataListSubject.onNext(sectionOfChatList)
            }
            .disposed(by: disposeBag)
        
        
        // 1. roomId에 해당하는 채팅 리스트 가져오기
        // 2. 채팅 리스트가 존재할 경우 cursor_date - 마지막 채팅 날짜 / 존재하지 않을 경우 cursor_date - 공백
        input.viewDidLoad
            .flatMap { [weak self] _ in
                guard let self else { return Single<Result<ChatListModel,Error>>.never()}
                let roomId = chatRoom.roomId
                let cursorDate = getCursorDate(roomId: chatRoom.roomId)
                return NetworkManager.shared.requestToServer(model: ChatListModel.self, router: ChatRouter.fetchChatHistory(id: roomId, fetchChatHistoryQuery: FetchChatHistoryQuery(cursor_date: cursorDate)))
            }
            .bind(with: self) { owner, result in
                let userNick = owner.getUserNick(chatRoom: owner.chatRoom)
                userNickRelay.accept(userNick ?? "")
                switch result {
                case .success(let chatListModel):
                    print(chatListModel.data)
                    if !chatListModel.data.isEmpty {
                        let chatRealmList = owner.getChatRealmList(chatList: chatListModel.data)
                        owner.chatRepository.createChatList(chat: chatRealmList)
                    }
                    let chatList = owner.getChatList(roomId: owner.chatRoom.roomId)
                    
                    let sectionOfChatList = owner.setSectionChatData(chatList: chatList)
                    sectionChatDataListSubject.onNext(sectionOfChatList)
                    // 소켓 연결
                    SocketIOManager.shared.fetchSocket(roomId: owner.chatRoom.roomId)
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        // 보내기 버튼 클릭
        input.sendButtonTapped
            .bind { _ in
                sendButtonTapped.accept(())
            }
            .disposed(by: disposeBag)
        
        // 내가 쓴 Content 보내기
        input.sendContent
            .flatMap { [weak self] myContent in
                guard let self else { return Single<Result<Chat, Error>>.never() }
                return NetworkManager.shared.requestToServer(model: Chat.self, router: ChatRouter.sendChat(id: chatRoom.roomId, sendChatQuery: SendChatQuery(content: myContent)))  // 서버에 채팅 전달
            }
            .bind(with: self) { owner, result in
                switch result {
                case .success(let chat):
                    print(chat)
                    let chatRealm = owner.getChatRealm(chat: chat)
                    owner.chatRepository.createChat(chat: chatRealm)    // DB에 채팅 저장
                    let chatList = owner.getChatList(roomId: owner.chatRoom.roomId)

                    sendContentSuccess.accept(())
                    let sectionOfChatList = owner.setSectionChatData(chatList: chatList)
                    sectionChatDataListSubject.onNext(sectionOfChatList)
                    
                case .failure(let error):
                    errorString.accept(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
        
        return Output(sectionChatDataList: sectionChatDataListSubject,
                      sendButtonTapped: sendButtonTapped.asDriver(onErrorDriveWith: .empty()),
                      sendContentSuccess: sendContentSuccess.asDriver(onErrorDriveWith: .empty()), 
                      userNick: userNickRelay.asDriver(onErrorJustReturn: ""),
                      errorString: errorString.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func getUserNick(chatRoom: ChatRoom) -> String? {
        for participant in chatRoom.participants {
            if participant.user_id != UserDefaultManager.shared.userId {
                return participant.nick
            }
        }
        return nil
    }
    
    private func setSectionChatData(chatList: [Chat]) -> [SectionOfChat] {

        var userChatData: [SectionOfChat.Row] = []
        var myChatData: [SectionOfChat.Row] = []
        var dateData: [SectionOfChat.Row] = []
        var sectionOfChatList: [SectionOfChat] = []
        
        for chat in chatList {
            if chat.sender.user_id == UserDefaultManager.shared.userId {
                print("나와 일치")
                myChatData = [.myChatData(myChatData: chat)]
                sectionOfChatList.append(.myChatSection(items: myChatData))
            } else {
                userChatData = [.userChatData(userChatData: chat)]
                sectionOfChatList.append(.userChatSection(items: userChatData))
            }
        }
        return sectionOfChatList
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
    
    private func getChatRealm(chat: Chat) -> ChatRealmModel {
        let chatRealmModel = ChatRealmModel(chatId: chat.chatId, roomId: chat.roomId, content: chat.content, createdAt: chat.createdAt, userId: chat.sender.user_id, nickname: chat.sender.nick, profileImage: chat.sender.profileImage)
        chat.files.forEach {
            chatRealmModel.files.append($0)
        }
        return chatRealmModel
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


enum SectionOfChat: SectionModelType {
    typealias ITEM = Row
    
    case userChatSection(items: [Row])
    case myChatSection(items: [Row])
    case dateSection(items: [Row])
    
    enum Row {
        case userChatData(userChatData: Chat)
        case myChatData(myChatData: Chat)
        case dateData(dateData: String)
    }
    
    var items: [Row] {
        switch self {
            case .userChatSection(let items): return items
            case .myChatSection(let items): return items
            case .dateSection(let items): return items
        }
    }
    
    init(original: SectionOfChat, items: [Row]) {
    switch original {
    case .userChatSection(_):
      self = .userChatSection(items: items)

    case .myChatSection(_):
      self = .myChatSection(items: items)
      
    case .dateSection(_):
    self = .dateSection(items: items)
    }
  }
 }
