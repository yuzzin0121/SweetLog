//
//  PostRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case uploadFiles
    case createPost(postQuery: PostRequestModel)
    case editPost(postId: String, postQuery: PostRequestModel)
    case loadImage(url: String)
    case fetchPosts(query: FetchPostQuery)
    case fetchPost(postId: String)
    case likePost(postId: String, likeStatusModel: LikeStatusModel)
    case deletePost(postId: String)
    
    case fetchUserPost(query: FetchPostQuery, userId: String)
    case fetchMyLikePost(query: FetchPostQuery)
    
    case searchHashtag(query: FetchPostQuery)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.payURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadFiles, .createPost, .likePost:
            return .post
            
        case .fetchPosts, .loadImage, .fetchPost, .fetchUserPost, .fetchMyLikePost, .searchHashtag:
            return .get
        case .editPost:
            return .put
        case .deletePost:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .uploadFiles:
            return "/v1/posts/files"
        case .createPost, .fetchPosts:
            return "/v1/posts"
        case .loadImage(let url):
            return "/v1/\(url)"
        case .fetchPost(let postId), .deletePost(let postId), .editPost(let postId, _):
            return "/v1/posts/\(postId)"
        case .likePost(let postId, _):
            return "/v1/posts/\(postId)/like"
        case .fetchUserPost(_, let userId):
            return "/v1/posts/users/\(userId)"
        case .fetchMyLikePost:
            return "/v1/posts/likes/me"
        case .searchHashtag:
            return "/v1/posts/hashtags"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .uploadFiles:
            return [
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken,
                HTTPHeader.contentType.rawValue:HTTPHeader.multipart.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue
            ]
        case .createPost, .fetchPost, .likePost, .fetchUserPost, .fetchMyLikePost, .deletePost, .searchHashtag, .editPost:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
       
            
        case .loadImage, .fetchPosts:
            return [
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
        case .uploadFiles, .createPost, .loadImage, .fetchPost, .likePost, .deletePost, .editPost:
            return nil
        case .fetchPosts(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: "5"),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        case .fetchUserPost(let query, _):
            return [
                URLQueryItem(name: "next", value: nil),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        case .searchHashtag(let query):
            return [
                URLQueryItem(name: "next", value: nil),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "product_id", value: query.product_id),
                URLQueryItem(name: "hashTag", value: query.hashTag)
            ]
        case .fetchMyLikePost(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: "200")
            ]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .uploadFiles, .loadImage, .fetchPosts, .fetchPost, .fetchUserPost, .fetchMyLikePost, .deletePost, .searchHashtag:
            return nil
        case .createPost(let postQuery):
            return try? encoder.encode(postQuery)
            
        case .editPost(let postId, let postQuery):
            return try? encoder.encode(postQuery)
        case .likePost(let postId, let likeStatusModel):
            return try? encoder.encode(likeStatusModel)
        }
    }
}

