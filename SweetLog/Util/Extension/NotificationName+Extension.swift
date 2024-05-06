//
//  NotificationName+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

extension Notification.Name {
    static let refreshTokenExpired = Notification.Name("refreshTokenExpired")
    static let fetchPosts = Notification.Name("fetchPosts")
    static let fetchMyProfile = Notification.Name("fetchMyProfile")
}
