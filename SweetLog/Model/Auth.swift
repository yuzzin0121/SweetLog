//
//  Auth.swift
//  SweetLog
//
//  Created by 조유진 on 4/12/24.
//

import Foundation

struct LoginModel: Decodable {
    let userId: String
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case accessToken
        case refreshToken
    }
}

struct RefreshModel: Decodable {
    let accessToken: String
}

struct ValidationModel: Decodable {
    let message: String
}

struct JoinModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
    }
}
