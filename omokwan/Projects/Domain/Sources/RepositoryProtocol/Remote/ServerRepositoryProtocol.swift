//
//  ServerRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 6/28/25
//

public protocol ServerRepositoryProtocol {
    func healthCheck() async -> Result<Bool, NetworkError>
}
