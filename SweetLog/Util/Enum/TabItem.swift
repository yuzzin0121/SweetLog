//
//  TabItem.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

enum TabItem {
    case home
    case tagSearch
    case map
    case profile
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .tagSearch: return "검색"
        case .map: return "베이커리 지도"
        case .profile: return "프로필"
        }
    }
    
    var image: UIImage {
        switch self {
        case .home: return Image.home
        case .tagSearch: return Image.search2
        case .map: return Image.map
        case .profile: return Image.profile
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home: return Image.homeFill
        case .tagSearch: return Image.search2
        case .map: return Image.mapFill
        case .profile: return Image.profileFill
        }
    }
}
