//
//  LocalRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 7/13/25
//

public protocol LocalRepositoryProtocol {
    func getAccessToken() -> String?
    func setAccessToken(_ accessToken: String) -> Bool
}
