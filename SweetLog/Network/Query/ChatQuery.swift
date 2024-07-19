//
//  ChatQuery.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import Foundation

struct CreateChatQuery: Encodable {
    let opponent_id: String
}

struct FetchChatHistoryQuery: Encodable {
    let cursor_date: String
}

struct SendChatQuery: Encodable {
    let content: String
    let files: [String] = []
}
