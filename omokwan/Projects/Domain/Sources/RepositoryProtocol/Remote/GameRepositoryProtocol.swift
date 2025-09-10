//
//  GameRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 7/26/25
//

public protocol GameRepositoryProtocol {
    func getGameInfosFromDate(dateString: String, isToday: Bool) async -> Result<[MyGameModel], NetworkError>
    func postCreateGame(_ configuration: MyGameAddConfiguration) async -> Result<Void, NetworkError>
    func getGameCategories() async -> Result<[GameCategory], NetworkError>
    func getDetailInfoWithPaging(gameID: Int, dateString: String, pageSize: Int) async -> Result<MyGameDetailInfo, NetworkError>
}
