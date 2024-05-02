//
//  Post.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

struct FetchPostModel: Decodable {
    let data: [FetchPostItem]
    let nextCursor: String
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([FetchPostItem].self, forKey: .data)
        self.nextCursor = try container.decode(String.self, forKey: .nextCursor)
    }
}

struct FetchPostItem: Decodable {
    let postId: String
    let productId: String?
    let title: String?
    let review: String
    let placeName: String
    let address: String
    let link: String
    let lonlat: String
    let sugar: String
    let createdAt: String
    let creator: Creator
    let files: [String]
    var likes: [String]
    let hashTags: [String]
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case productId = "product_id"
        case title
        case review = "content"
        case placeName = "content1"
        case address = "content2"
        case link = "content3"
        case lonlat = "content4"
        case sugar = "content5"
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
        self.productId = try container.decodeIfPresent(String.self, forKey: .productId)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.review = try container.decode(String.self, forKey: .review)
        self.placeName = try container.decode(String.self, forKey: .placeName)
        self.address = try container.decode(String.self, forKey: .address)
        self.link = try container.decode(String.self, forKey: .link)
        self.lonlat = try container.decode(String.self, forKey: .lonlat)
        self.sugar = try container.decode(String.self, forKey: .sugar)
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

struct FilesModel: Decodable {
    let files: [String]
}

