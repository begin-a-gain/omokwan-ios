//
//  String+Extension.swift
//  Util
//
//  Created by 김동준 on 7/13/25
//

import Foundation

public extension String {
    func checkRegexValidation(pattern regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
    
    var unicodeEmoji: String {
        let hex = self.replacingOccurrences(of: "U+", with: "")
        if let scalarValue = UInt32(hex, radix: 16),
           let scalar = UnicodeScalar(scalarValue) {
            return String(scalar)
        }
        return self
    }
    
    func toDate(timeZone: TimeZone = TimeZone(identifier: "Asia/Seoul") ?? .current) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = timeZone
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: self)
    }
}
