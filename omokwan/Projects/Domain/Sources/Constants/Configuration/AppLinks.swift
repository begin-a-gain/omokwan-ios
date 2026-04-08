//
//  AppLinks.swift
//  Domain
//
//  Created by jumy on 3/26/26.
//

public enum AppLinks {
    case privacyPolicy
    case termsOfService
    case appstore
    
    public var link: String {
        switch self {
        case .privacyPolicy:
            "https://www.notion.so/32d2d47341bb806688c7d006d65a498e?source=copy_link"
        case .termsOfService:
            "https://www.notion.so/32d2d47341bb80a3947bc2e79f86c679?source=copy_link"
        case .appstore:
            "https://apps.apple.com/us/app/%EC%98%A4%EB%AA%A9%EC%99%84/id6761292354"
        }
    }
}
