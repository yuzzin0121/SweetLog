//
//  Chat.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import Foundation

struct ChatRoomListModel: Decodable {
    let data: [ChatRoom]
}


struct ChatRoom: Decodable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [User]
    let lastChat: [Chat]
    
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
        self.lastChat = try container.decode([Chat].self, forKey: .lastChat)
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
