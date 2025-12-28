//
//  Data+Extension.swift
//  Util
//
//  Created by 김동준 on 12/28/25
//

import Foundation

public extension Data {
    func prettyJSONString() -> String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self),
            JSONSerialization.isValidJSONObject(object),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .withoutEscapingSlashes]
            )
        else {
            return nil
        }

        return String(decoding: prettyData, as: UTF8.self)
    }
}
