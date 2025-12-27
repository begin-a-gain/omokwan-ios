//
//  AccountRepositoryProtocol.swift
//  Domain
//
//  Created by 김동준 on 9/15/24
//

public protocol AccountRepositoryProtocol {
    func postSignIn(provider: String, accessToken: String) async -> Result<SignInResult, NetworkError>
    func postNicknameDuplicated(nickname: String) async -> Result<NicknameDuplicateValidation, NetworkError>
    func putNickname(nickname: String) async -> Result<Void, NetworkError>
    func getUserInfo() async -> Result<UserInfo, NetworkError>
    func postDeletionSurvey(reasons: [String], otherReasonText: String?) async -> Result<Void, NetworkError>
    func deleteUserAccount() async -> Result<Void, NetworkError>
}
