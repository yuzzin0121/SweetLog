//
//  UserDefaultManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/13/24.
//

import Foundation

// singleton pattern
// 유일한 인스턴스를 하나만 생성
final class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    enum UDKey: String, CaseIterable {
        case userId
        case accessToken
        case refreshToken
        case following
    }
    
    let ud = UserDefaults.standard
    
    var userId: String{
        get { ud.string(forKey: UDKey.userId.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.userId.rawValue) }
    }
    var accessToken: String{
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    var refreshToken: String{
        get { ud.string(forKey: UDKey.refreshToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.refreshToken.rawValue) }
    }
    var following: [String] {
        get { ud.array(forKey: UDKey.following.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.following.rawValue) }
    }
}
