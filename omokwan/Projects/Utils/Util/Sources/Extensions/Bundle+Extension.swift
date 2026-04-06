//
//  Bundle+Extension.swift
//  Util
//
//  Created by 김동준 on 11/3/25
//

import Foundation

public extension Bundle {
    var appVersion: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "-"
    }
    
    var buildNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "-"
    }
    
    var fullVersion: String {
        "\(appVersion) (\(buildNumber))"
    }
}
