//
//  PostRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case postFiles
    case createPost
    case loadImage(url: String)
    case fetchPost(query: FetchPostQuery)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postFiles, .createPost:
            return .post
            
        case .fetchPost, .loadImage:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .postFiles:
            return "v1/"
        case .createPost, .fetchPost:
            return "v1/posts"
        case .loadImage(let url):
            return "v1/\(url)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .postFiles:
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
        case .postFiles, .createPost, .loadImage:
            return nil
        case .fetchPost(let query):
            return [
                URLQueryItem(name: "next", value: query.next),
                URLQueryItem(name: "limit", value: query.limit),
                URLQueryItem(name: "product_id", value: query.product_id)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .createPost, .postFiles, .loadImage:
            return nil
        case .fetchPost:
            return nil
        }
    }
}

