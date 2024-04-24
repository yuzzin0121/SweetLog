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
    case fetchPost(query: FetchPostQuery)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .uploadFiles, .createPost:
            return .post
            
        case .fetchPost, .loadImage:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .uploadFiles:
            return "/v1/posts/files"
        case .createPost, .fetchPost:
            return "/v1/posts"
        case .loadImage(let url):
            return "/v1/\(url)"
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
        case .createPost:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaultManager.shared.accessToken
            ]
       
            
        case .loadImage, .fetchPost:
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
        case .uploadFiles, .createPost, .loadImage:
            return nil
        case .fetchPost(let query):
            return [
                URLQueryItem(name: "next", value: nil),
                URLQueryItem(name: "limit", value: "200"),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .uploadFiles, .loadImage, .fetchPost:
            return nil
        case .createPost(let postQuery):
            let encoder = JSONEncoder()
            return try? encoder.encode(postQuery)
        }
    }
}

