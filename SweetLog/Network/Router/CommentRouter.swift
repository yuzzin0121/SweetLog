//
//  CommentRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//
import Foundation
import Alamofire

enum CommentRouter {
    case createComment(postId: String, contentQuery: ContentQuery)
}

extension CommentRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createComment:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createComment(let postId, _):
            return "/v1/posts/\(postId)/comments"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createComment:
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
        switch self {
        case .createComment:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .createComment(let postId, let contentQuery):
            let encoder = JSONEncoder()
            return try? encoder.encode(contentQuery)
        }
    }
}
