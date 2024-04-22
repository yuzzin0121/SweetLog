//
//  KakaoPlaceRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import Foundation
import Alamofire

enum KakaoPlaceRouter {
    case searchPlace(query: String)
}

extension KakaoPlaceRouter: TargetType {
    
    var baseURL: String {
        return APIKey.kakaoURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchPlace:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchPlace:
            return "local/search/keyword.json"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .searchPlace:
            return [
                HTTPHeader.authorization.rawValue: APIKey.kakaoKey.rawValue
            ]
        }
    }
        
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchPlace(let query):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "category_group_code", value: "FD6") // 음식정
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .searchPlace:
            return nil
        }
    }
}

