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
    case loadImage(url: String)
    case fetchPosts(query: FetchPostQuery)
    case fetchPost(postId: String)
    case likePost(postId: String, likeStatusModel: LikeStatusModel)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadFiles, .createPost, .likePost:
            return .post
            
        case .fetchPosts, .loadImage, .fetchPost:
            return .get
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
        case .fetchPost(let postId):
            return "/v1/posts/\(postId)"
        case .likePost(let postId, _):
            return "/v1/posts/\(postId)/like"
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
        case .createPost, .fetchPost, .likePost:
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
        case .uploadFiles, .createPost, .loadImage, .fetchPost, .likePost:
            return nil
        case .fetchPosts(let query):
            return [
                URLQueryItem(name: "next", value: nil),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        switch self {
        case .uploadFiles, .loadImage, .fetchPosts, .fetchPost:
            return nil
        case .createPost(let postQuery):
            return try? encoder.encode(postQuery)
        case .likePost(let postId, let likeStatusModel):
            return try? encoder.encode(likeStatusModel)
        }
    }
}

