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
    
    func formattedUpdatedDate(_ dateString: String) -> String? {
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = isoFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "M/d hh:mm"
            let formattedDateString = dateFormatter.string(from: date)
            return formattedDateString
        }
        return nil
    }
}
