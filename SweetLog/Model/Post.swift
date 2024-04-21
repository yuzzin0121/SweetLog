//
//  Post.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

struct FetchPostModel: Decodable {
    let data: [FetchPostItem]?
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([FetchPostItem].self, forKey: .data)
        self.nextCursor = try container.decode(String.self, forKey: .nextCursor)
    }
}

struct FetchPostItem: Decodable {
    let postId: String
    let productId: String
    let title: String?
    let content: String
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
    let createdAt: String
    let creator: Creator
    let files: [String]
    let likes: [String]
    let hashTags: [String]
    let comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case content
        case content1
        case content2
        case content3
        case content4
        case content5
        case createdAt
        case creator
        case files
        case likes
        case hashTags
        case comments
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(String.self, forKey: .postId)
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId) ?? ""
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.content1 = try container.decodeIfPresent(String.self, forKey: .content1)
        self.content2 = try container.decodeIfPresent(String.self, forKey: .content2)
        self.content3 = try container.decodeIfPresent(String.self, forKey: .content3)
        self.content4 = try container.decodeIfPresent(String.self, forKey: .content4)
        self.content5 = try container.decodeIfPresent(String.self, forKey: .content5)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.creator = try container.decode(Creator.self, forKey: .creator)
        self.files = try container.decode([String].self, forKey: .files)
        self.likes = try container.decode([String].self, forKey: .likes)
        self.hashTags = try container.decode([String].self, forKey: .hashTags)
        self.comments = try container.decode([Comment].self, forKey: .comments)
    }
}

struct Creator: Decodable {
    let userId: String
    let nickname: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nickname = "nick"
        case profileImage
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
    }
}

struct Comment: Decodable {
    let commentId: String
    let content: String
    let createdAt: String
    let creator: Creator
    
    enum CodingKeys: String, CodingKey {
        case commentId = "comment_id"
        case content
        case createdAt
        case creator
    }
}
