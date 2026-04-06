//
//  HostChangeFeature.swift
//  GameDetail
//
//  Created by 김동준 on 9/23/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct HostChangeFeature {
    @Dependency(\.gameUseCase) private var gameUseCase
    
    public init() {}
    
    public struct State: Equatable {
        public init(
            gameID: Int,
            gameUserInfos: [GameUserInfo]
        ) {
            self.gameID = gameID
            self.gameUserInfos = gameUserInfos
        }
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()

        var isLoading: Bool = false
        let gameID: Int
        let gameUserInfos: [GameUserInfo]
        
        var participants: [GameParticipantInfo] = []
        var selectedParticipant: GameParticipantInfo?
        var isBottomButtonEnable: Bool {
            guard let selectedParticipant = selectedParticipant else {
                return false
            }
            
            return selectedParticipant.isHost == false
        }
    }
    
    public enum Action {
        case onAppear
        case navigateToBack
        case changeButtonTapped
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case participantsFetched([GameParticipantInfo])
        case participantTapped(GameParticipantInfo)
        case hostUpdated
        case notifyHostChanged(String)
        case hostChangedWithData([GameUserInfo])
    }
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let gameID = state.gameID
                return .run { send in
                    await send(fetchUserInfo(gameID))
                }
            case .navigateToBack:
                return .none
            case .changeButtonTapped:
                guard let host = state.selectedParticipant else { return .none }
                state.isLoading = true
                let gameID = state.gameID
                
                return .run { send in
                    await send(updateHost(gameID, host.userId))
                }
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .participantsFetched(let participants):
                state.isLoading = false
                
                state.participants = applyHostInfoFromGameUsers(
                    participants: participants,
                    users: state.gameUserInfos
                )
                
                return .none
            case .participantTapped(let participant):
                if state.selectedParticipant?.userId == participant.userId {
                    state.selectedParticipant = nil
                } else {
                    state.selectedParticipant = participant
                }

                return .none
            case .hostUpdated:
                state.isLoading = false
                guard let host = state.selectedParticipant else { return .none }
                let hostChangedGameUserInfos = state.gameUserInfos.map {
                    GameUserInfo(userID: $0.userID, nickname: $0.nickname, isHost: $0.userID == host.userId)
                }
                
                return .concatenate([
                    .send(.notifyHostChanged(host.nickname)),
                    .send(.hostChangedWithData(hostChangedGameUserInfos))
                ])
            case .notifyHostChanged:
                return .none
            case .hostChangedWithData:
                return .none
            }
        }
    }
}

private extension HostChangeFeature {
    func fetchUserInfo(_ gameID: Int) async -> Action {
        let response = await gameUseCase.fetchGameParticipants(gameID)
        switch response {
        case .success(let participants):
            return .participantsFetched(participants)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func updateHost(_ gameID: Int, _ userID: Int) async -> Action {
        let response = await gameUseCase.updateGameHost(gameID, userID)
        switch response {
        case .success:
            return .hostUpdated
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func applyHostInfoFromGameUsers(
        participants: [GameParticipantInfo],
        users: [GameUserInfo]
    ) -> [GameParticipantInfo] {
        
        participants.map { participant in
            var updated = participant
            updated.isHost = users
                .first { $0.userID == participant.userId }?
                .isHost ?? false
            return updated
        }
    }
}
