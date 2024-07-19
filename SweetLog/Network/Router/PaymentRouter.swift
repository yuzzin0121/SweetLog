//
//  PaymentRouter.swift
//  SweetLog
//
//  Created by 조유진 on 5/12/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validation(PaymentValidationQuery)
    case payDetail
}

extension PaymentRouter: TargetType {
    var baseURL: String {
        APIKey.baseURL.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .validation: .post
        case .payDetail: .get
        }
    }
    
    var path: String {
        switch self {
        case .validation: "/v1/payments/validation"
        case .payDetail: "/v1/payments/me"
        }
    }
    
    var header: [String : String] {
        return [
            HTTPHeader.sesacKey.rawValue: APIKey.sesacKey.rawValue,
            HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
        ]
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
        case .validation(let query):
            encoder.keyEncodingStrategy = .useDefaultKeys
            return try? encoder.encode(query)
        default: return nil
        }
    }
}
