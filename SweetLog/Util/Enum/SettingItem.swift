//
//  SettingItem.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import Foundation
import UIKit

enum SettingItem: Int, CaseIterable {
    case paymentDetails
    case logout
    case withdraw
    
    var title: String {
        switch self {
        case .logout:
            return "로그아웃"
        case .withdraw:
            return "탈퇴하기"
        case .paymentDetails:
            return "결제 내역"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .logout, .paymentDetails:
            return Color.black
        case .withdraw:
            return Color.validRed
        }
    }
}
