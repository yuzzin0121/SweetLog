//
//  String+Extension.swift
//  SweetLog
//
//  Created by 조유진 on 5/4/24.
//

import UIKit

extension String {
    static func unTaggedText(text: String) -> String {
        // 해시태그를 포함한 패턴을 사용하여 텍스트에서 제거
        let regex = try! NSRegularExpression(pattern: "#[^\\s]+", options: [])
        let range = NSRange(text.startIndex..<text.endIndex, in: text)
        
        // 해시태그 제거
        let newText = regex.stringByReplacingMatches(in: text, options: [], range: range, withTemplate: "")
        let result = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        return result
    }
}

