//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 김동준 on 11/2/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct MyPageFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        @Shared(.userInfo) var userInfo = UserInfo()
        var info: MyPageGameInfo = .init()
        var isLoading: Bool = false
        var isInitFectehd: Bool = true
    }

    public enum Action {
        case onAppear
        case nicknameTapped
        case logoutButtonTapped
        case navigateToEditNickname
        case deleteAccountButtonTapped
        case navigateToAccountDelete
        case navigateToMyPageGameDetail(MyPageGameDetailType, MyPageGameInfo)
        case passError(NetworkError)
        case myPageGameInfoFetched(MyPageGameInfo)
        case setLoading(Bool)
        case dataFetchFailed(NetworkError)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let userID = state.userInfo.id
                let isInitFectehd = state.isInitFectehd
                if isInitFectehd { state.isInitFectehd = false }
                
                return .merge([
                    .send(.setLoading(isInitFectehd)),
                    .run { send in
                        await send(fetchMyPageGameInfo(userID))
                    }
                ])
            case .nicknameTapped:
                return .send(.navigateToEditNickname)
            case .logoutButtonTapped:
                return .none
            case .navigateToEditNickname:
                return .none
            case .deleteAccountButtonTapped:
                return .send(.navigateToAccountDelete)
            case .navigateToAccountDelete:
                return .none
            case .navigateToMyPageGameDetail:
                return .none
            case .passError:
                return .none
            case .myPageGameInfoFetched(let info):
                state.info = info
                return .send(.setLoading(false))
            case .setLoading:
                return .none
            case .dataFetchFailed(let error):
                return .merge([
                    .send(.setLoading(false)),
                    .send(.passError(error))
                ])
            }
        }
    }
}

private extension MyPageFeature {
    func fetchMyPageGameInfo(_ userID: Int) async -> Action {
        let response = await gameUseCase.fetchMyPageGameInfo(userID)
        switch response {
        case .success(let info):
            return .myPageGameInfoFetched(info)
        case let .failure(error):
            return .dataFetchFailed(error)
        }
    }
}
