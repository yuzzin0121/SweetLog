//
//  UILabel+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 4/22/24.
//

import UIKit

extension UILabel {
    func design(text: String = "",
                textColor: UIColor = Color.black,
                font: UIFont = .pretendard(size: 14, weight: .regular),
                textAlignment: NSTextAlignment = .left,
                numberOfLines: Int = 1) {
        self.text = text
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
}
