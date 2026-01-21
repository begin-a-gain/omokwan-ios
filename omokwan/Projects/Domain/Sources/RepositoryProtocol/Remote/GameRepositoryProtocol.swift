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
    func getDetailUserInfo(gameID: Int, userID: Int) async -> Result<DetailUserInfo, NetworkError>
    func putTodayGameStatus(_ gameID: Int) async -> Result<OmokStoneStatus, NetworkError>
    func postParticipateRoom(gameID: Int, password: String?) async -> Result<Bool, NetworkError>
    func getAllGameInfoList(_ request: GameRoomInformationRequestModel) async -> Result<GameRoomInfo, NetworkError>
    func getGameParticipants(gameID: Int) async -> Result<[GameParticipantInfo], NetworkError>
    func putGameHost(gameID: Int, userID: Int) async -> Result<Void, NetworkError>
    func getGameDetailSetting(gameID: Int) async -> Result<GameDetailSettingConfiguration, NetworkError>
}
