//
//  Profile.swift
//  SweetLog
//
//  Created by 조유진 on 4/12/24.
//

import Foundation

struct ProfileModel: Decodable {
    let userId: String
    let email: String?
    let nickname: String
    let followers: [User]
    let following: [User]
    let posts: [String]
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nickname = "nick"
        case followers
        case following
        case posts
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.followers = try container.decode([User].self, forKey: .followers)
        self.following = try container.decode([User].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
    }
}

struct User: Decodable {
    let userId: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
    }
}
