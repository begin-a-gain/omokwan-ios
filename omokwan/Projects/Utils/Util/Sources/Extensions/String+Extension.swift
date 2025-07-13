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
}
