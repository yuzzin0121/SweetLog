//
//  FormatterManager.swift
//  SweetLog
//
//  Created by 조유진 on 4/18/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    private init() { }
    private let dateFormatter = DateFormatter()
    
    func formattedDate(_ dateString: String) -> String? {
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = isoFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "M월 d일 hh:mm"
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        }
        return nil
    }
    
    func formattedUpdatedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let displayFormatter = DateFormatter()
        displayFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let inputDate = dateFormatter.date(from: dateString) else {
            return "잘못된 날짜 형식"
        }
        
        let today = Date()
        let second = today.timeIntervalSince(inputDate)
        
        if second < 3600 {
            let minute = max(1, Int(second / 60))
            return "\(minute)분 전"
        } else if second < 86400 {
            let hour = Int(second / 3600)
            return "\(hour)시간 전"
        } else {
            displayFormatter.dateFormat = "yyyy.MM.dd"
            return displayFormatter.string(from: inputDate)
        }

    }
}


final class NumberFomatterManager {
    static let shared = NumberFomatterManager()
    private init() { }
    private let numberFormatter = NumberFormatter()
    
    func formattedNumber(_ number: Int) -> String {
        numberFormatter.numberStyle = .decimal
        guard let result = numberFormatter.string(from: number as NSNumber) else { return "0" }
        return result
    }
}
