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
    var followers: [User]
    var following: [User]
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
    let user_id: String
    let nick: String
    let profileImage: String?
}


struct FollowStatus: Decodable {
    let nickname: String
    let opponentNick: String
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickname = "nick"
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
}
