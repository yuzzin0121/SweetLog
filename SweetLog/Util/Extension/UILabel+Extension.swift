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
    
    func setLineSpacing(spacing: CGFloat) {
           guard let text = text else { return }

           let attributeString = NSMutableAttributedString(string: text)
           let style = NSMutableParagraphStyle()
           style.lineSpacing = spacing
           attributeString.addAttribute(.paragraphStyle,
                                        value: style,
                                        range: NSRange(location: 0, length: attributeString.length))
           attributedText = attributeString
    }

    func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
    
    func changeFont(targetString: String, font: UIFont) {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: font, range: (text as NSString).range(of: targetString))
                                      
        self.attributedText = attributedString
    }
}
