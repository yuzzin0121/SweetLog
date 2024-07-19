//
//  Chat.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import Foundation
import RealmSwift

struct ChatRoomListModel: Decodable {
    let data: [ChatRoom]
}


struct ChatRoom: Decodable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [User]
    let lastChat: Chat
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.participants = try container.decode([User].self, forKey: .participants)
        self.lastChat = try container.decode(Chat.self, forKey: .lastChat)
    }
}

// 채팅
struct Chat: Decodable {
    let chatId: String
    let roomId: String
    let content: String
    let createdAt: String
    let sender: User
    let files: [String]
}

final class ChatRealmModel: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var roomId: String
    @Persisted var content: String
    @Persisted var createdAt: String
    @Persisted var files: List<String>
    @Persisted var userId: String
    @Persisted var nickname: String
    @Persisted var profileImage: String?
    
    convenience init(chatId: String, roomId: String, content: String, createdAt: String, files: List<String>, userId: String, nickname: String, profileImage: String) {
        self.init()
        self.chatId = chatId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = files
        self.userId = userId
        self.nickname = nickname
        self.profileImage = profileImage
    }
}
