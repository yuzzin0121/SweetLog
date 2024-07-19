//
//  ChatRouter.swift
//  SweetLog
//
//  Created by 조유진 on 7/19/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case fetchChatroomList
    case createChatroom(chatQuery: CreateChatQuery)
    case fetchChatHistory(id: String, fetchChatHistoryQuery: FetchChatHistoryQuery)
    case sendChat(id: String, sendChatQuery: SendChatQuery)
    case uploadChatImage(id: String)
}

extension ChatRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchChatroomList, .fetchChatHistory:
            return .get
        case .createChatroom, .sendChat, .uploadChatImage:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchChatroomList, .createChatroom:
            return "/v1/chats"
        case .fetchChatHistory(let id, _), .sendChat(let id, _):
            return "/v1/chats/\(id)"
        case .uploadChatImage(let id):
            return "/v1/chats/\(id)/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .uploadChatImage:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
        default:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .createChatroom(let chatQuery):
            return try? encoder.encode(chatQuery)
        case .fetchChatHistory(_, let fetchChatHistoryQuery):
            return try? encoder.encode(fetchChatHistoryQuery)
        case .sendChat(_, let sendChatQuery):
            return try? encoder.encode(sendChatQuery)
        default: return nil
        }
    }
}
