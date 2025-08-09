//
//  GameRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 7/26/25
//

public protocol GameRepositoryProtocol {
    func getGameInfosFromDate(dateString: String) async -> Result<[MyGameModel], NetworkError>
    func postCreateGame(_ configuration: MyGameAddConfiguration) async -> Result<Void, NetworkError>
}
