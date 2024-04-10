//
//  UIFont+Pretendard.swift
//  SweetLog
//
//  Created by 조유진 on 4/11/24.
//

import UIKit

extension UIFont {
    enum PretendardWeight: String {
        case black      = "Black"
        case extraBold  = "ExtraBold"
        case bold       = "Bold"
        case semiBold   = "SemiBold"
        case medium     = "Medium"
        case regular    = "Regular"
        case light      = "Light"
        case extraLight = "ExtraLight"
        case thin       = "Thin"
    }

    static func pretendard(size: CGFloat, weight: PretendardWeight) -> UIFont {
        return UIFont(name: "Pretendard-\(weight.rawValue)", size: size)!
    }
}
