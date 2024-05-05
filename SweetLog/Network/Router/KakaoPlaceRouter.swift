//
//  KakaoPlaceRouter.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import Foundation
import Alamofire

enum KakaoPlaceRouter {
    case searchPlace(query: SearchPlaceQuery)
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
            let radius = query.radius == nil ? "" : "\(query.radius!)"
            return [
                
                URLQueryItem(name: "query", value: query.query),
                URLQueryItem(name: "category_group_code", value: query.category_group_code ?? ""),  // 음식점
                URLQueryItem(name: "x", value: query.x ?? ""),
                URLQueryItem(name: "y", value: query.y ?? ""),
                URLQueryItem(name: "radius", value: radius),
                URLQueryItem(name: "rect", value: query.rect ?? ""),
                URLQueryItem(name: "page", value: "\(query.page)"),
                URLQueryItem(name: "sort", value: query.sort ?? "")
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

