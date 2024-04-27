//
//  LikeQuery.swift
//  SweetLog
//
//  Created by 조유진 on 4/27/24.
//

import Foundation

struct LikeStatusModel: Codable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
}
