//
//  String+Extension.swift
//  Util
//
//  Created by 김동준 on 7/13/25
//

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
}
