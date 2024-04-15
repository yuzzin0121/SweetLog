//
//  SettingItem.swift
//  SweetLog
//
//  Created by 조유진 on 4/15/24.
//

import Foundation
import UIKit

enum SettingItem: Int, CaseIterable {
    case withdraw
    
    var title: String {
        switch self {
        case .withdraw:
            return "탈퇴하기"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .withdraw:
            return Color.validRed
        }
    }
}
