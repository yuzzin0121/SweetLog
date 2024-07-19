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
    case editComment(postId: String, commentId: String, editCommentQuery: EditCommentQuery)
    case deleteComment(postId: String, commentId: String)
}

extension CommentRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .createComment:
            return .post
        case .editComment:
            return .put
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createComment(let postId, _):
            return "/v1/posts/\(postId)/comments"
        case .editComment(let postId, let commentId, _), .deleteComment(let postId, let commentId):
            return "/v1/posts/\(postId)/comments/\(commentId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createComment, .editComment, .deleteComment:
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
        case .createComment, .editComment, .deleteComment:
            return nil
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .deleteComment:
            return nil
        case .createComment(let postId, let contentQuery):
            return try? encoder.encode(contentQuery)
        case .editComment(_, _, let editCommentQuery):
            return try? encoder.encode(editCommentQuery)
        }
    }
}
