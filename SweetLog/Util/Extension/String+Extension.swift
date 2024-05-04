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
    
    static func getListToString(array: [String]) -> String {
        var tagString = ""
        for text in array {
            tagString.append("#\(text)  ")
        }
        let result = tagString.trimmingCharacters(in: [" "])
        return result
    }
    
    static func getLastCategory(category: String) -> String {
        // '>'를 구분자로 사용하여 문자열을 분할
        let components = category.split(separator: ">").map(String.init)

        // 마지막 요소 추출 및 앞뒤 공백 제거
        if let lastItem = components.last {
            let result = lastItem.trimmingCharacters(in: .whitespacesAndNewlines)
            return result
        }
        return category
    }
    
    static func getFomattedDistance(_ distance: String) -> String? {
        guard let value = Int(distance) else { return nil }
        
        if value < 1000 {
            return "\(value)m"
        } else {
            let kilometers = Double(value) / 1000.0
            let formattedKilometers = String(format: "%.0fkm", kilometers)
            return formattedKilometers
        }
    }
}

