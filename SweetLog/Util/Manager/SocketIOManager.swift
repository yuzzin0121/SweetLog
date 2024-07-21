//
//  SocketIOManager.swift
//  SweetLog
//
//  Created by 조유진 on 7/15/24.
//

import Foundation
import SocketIO
import RxCocoa

final class SocketIOManager {

    static var shared: SocketIOManager = SocketIOManager()

    var manager: SocketManager!
    var socket: SocketIOClient!

    var receivedUserChat = PublishRelay<Chat>()
    
    private init() {}

    func fetchSocket(roomId: String) {
        manager = SocketManager(socketURL: URL(string: APIKey.baseURL.rawValue)!, config: [.log(true), .compress])

        socket = manager.socket(forNamespace: "/chats-\(roomId)")

        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected", data, ack)
        }

        // View에서 소켓 연결이 필요한 시점에 호출하는 메서드
        // socket.connect()를 통해 소켓 연결이 성공적일 경우 init에 구현된 .connect 이벤트를 수신해 SOCKET IS CONNECTED가 출력된다.
        socket.on(clientEvent: .disconnect) { data, ack in
            print("socket disconnected", data, ack)
        }

        // 소켓이 연결된 이후, "chat" 이벤트를 통해 채팅 수신 가능
        socket.on("chat") { dataArray, ack in
            print("chat received", dataArray, ack )

            if let data = dataArray.first {
                do {
                    let result = try JSONSerialization.data(withJSONObject: data)
                    let chat = try JSONDecoder().decode(Chat.self, from: result)
                    self.receivedUserChat.accept(chat)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
  }

    func establishConnection() {
        socket?.connect()
    }

    // View에서 소켓 해제가 필요한 시점에 호출되는 메서드
    // socket.disconnect()를 통해 소켓 해제가 성공적일 경우 init에 구현된 .disconnect 이벤트를 수신해 SOKET IS DISCONNECTED가 출력된다.
    func leaveConnection() {
        socket?.disconnect()
    }
}


// 소켓에 대한 응답
/*
 {
 "chat_id": "6638760febbb7675457ca1cf", 
 "room_id": "6638664652ba24c89bb29379",
 "content": " ",
 "createdAt": "2024-05-06T06:17:51.602Z",
 "sender": {
    "user_id": "66323d82c4f77d8f8983dffa",
    "nick": "sessac ",
    "profileImage": "uploads/profiles/1714923493759.png"
},
 "files": [
         "uploads/chats/jpeg_2_1714972596966.jpeg",
        "uploads/chats/giphy_1714972596971.gif",
         "uploads/chats/pdf_1714972596974.pdf"
 ] }
 */
