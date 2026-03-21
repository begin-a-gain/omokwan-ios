//
//  MyGameFeature.swift
//  MyGame
//
//  Created by 김동준 on 11/23/24
//

import ComposableArchitecture
import Foundation
import Domain
import Util

@Reducer
public struct MyGameFeature {
    @Dependency(\.gameUseCase) private var gameUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case participateDoubleCheck(MyGameModel)
            case password(MyGameModel)
            case passwordError
        }
        
        @BindingState var selectedDate: Date = .now
        @BindingState public var thousandsPlace: String = ""
        @BindingState public var hundredsPlace: String = ""
        @BindingState public var tensPlace: String = ""
        @BindingState public var onesPlace: String = ""
        @PresentationState var myGameSheet: MyGameSheetFeature.State?
        var isDatePickerVisible: Bool = false
        var hasNotification: Bool = false
        var myGameList: [MyGameModel?] = Array(repeating: nil, count: 6)
        
        var isGameAddFloatingMessageVisible: Bool {
            return !myGameList.contains(where: { $0 != nil })
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case binding(BindingAction<State>)
        case dateArrowLeftButtonTapped
        case dateArrowRightButtonTapped
        case datePickerButtonTapped
        case navigateToMyGameAddCategory
        case navigateToNotification
        case bellButtonTapped
        case myGameSheet(PresentationAction<MyGameSheetFeature.Action>)
        case gameCreated(String)
        case initialDataFetched([MyGameModel], Bool)
        case noAction
        case setLoading(Bool)
        case fetchGameInfo
        case passError(NetworkError)
        case stoneTapped(MyGameModel)
        case quickCompleteButtonTapped(MyGameModel)
        case navigateToGameDetail(Int, String, String)
        case omokStatusUpdated(Int)
        case passAlert(State.AlertCase)
        case alertParticipateButtonTapped(MyGameModel)
        case passwordAlertCancelButtonTapped
        case passwordAlertConfirmButtonTapped(MyGameModel)
        case participateRoom(MyGameModel, String?)
        case participateCompleted(MyGameModel)
        case sendToast(String)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchGameInfo)
            case .fetchGameInfo:
                let dateString = state.selectedDate.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                let isToday = Date.now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat) == dateString
                return .merge([
                    .send(.setLoading(true)),
                    .run { send in
                        await send(fetchInitialData(dateString, isToday))
                    }
                ])
            case .binding:
                return .none
            case .dateArrowLeftButtonTapped:
                guard let date = state.selectedDate.addDay(-1) else {
                    return .none
                }
                
                state.selectedDate = date
                return .send(.fetchGameInfo)
            case .dateArrowRightButtonTapped:
                guard let date = state.selectedDate.addDay(1) else {
                    return .none
                }
                
                state.selectedDate = date
                return .send(.fetchGameInfo)
            case .datePickerButtonTapped:
                state.myGameSheet = .init(selectedDate: state.selectedDate)
                return .none
            case .navigateToMyGameAddCategory:
                return .none
            case .navigateToNotification:
                return .none
            case .myGameSheet(let action):
                switch action {
                case .presented(let sheetAction):
                    switch sheetAction {
                    case .dismissSheetWithData(let date):
                        state.myGameSheet = nil
                        state.selectedDate = date
                        return .send(.fetchGameInfo)
                    default:
                        return .none
                    }
                case .dismiss:
                    return .none
                }
            case .bellButtonTapped:
                return .send(.navigateToNotification)
            case .gameCreated(let title):
                // TODO: 대국 생성 완료 토스트 생성
                print("DONGJUN -> \(title) 생성 완료")
                return .none
            case let .initialDataFetched(myGameModels, hasNotification):
                state.hasNotification = hasNotification
                state.myGameList = []
                addListValueToMyGameList(myGameModels, state: &state)
                checkAndAppendNilIfNeeded(state: &state)
                return .send(.setLoading(false))
            case .noAction:
                return .send(.setLoading(false))
            case .setLoading:
                return .none
            case .passError:
                return .none
            case .stoneTapped(let stoneInfo):
                return validateParticipateStatus(stoneInfo, selectedDate: state.selectedDate)
            case .quickCompleteButtonTapped(let stoneInfo):
                switch stoneInfo.participateStatus {
                case .active:
                    switch stoneInfo.myGameCompleteStatus {
                    case .inComplete:
                        return .concatenate([
                            .send(.setLoading(true)),
                            .run { send in
                                await send(updateTodayOmokStatus(stoneInfo.gameID))
                            }
                        ])
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case let .omokStatusUpdated(gameID):
                state.myGameList = state.myGameList.map { (game: MyGameModel?) -> MyGameModel? in
                    guard let game else { return nil }
                    guard game.gameID == gameID else { return game }

                    return MyGameModel(
                        gameID: game.gameID,
                        name: game.name,
                        onGoingDays: game.onGoingDays,
                        participants: game.participants,
                        maxParticipants: game.maxParticipants,
                        myGameCompleteStatus: .complete,
                        participateStatus: game.participateStatus,
                        isPrivateRoom: game.isPrivateRoom
                    )
                }
                return .send(.setLoading(false))
            case .passAlert:
                return .send(.setLoading(false))
            case .alertParticipateButtonTapped(let stoneInfo):
                if stoneInfo.isPrivateRoom {
                    return .send(.passAlert(.password(stoneInfo)))
                }
                
                return .send(.participateRoom(stoneInfo, nil))
            case .passwordAlertCancelButtonTapped:
                return .none
            case .passwordAlertConfirmButtonTapped(let stoneInfo):
                guard let password = [
                    state.thousandsPlace,
                    state.hundredsPlace,
                    state.tensPlace,
                    state.onesPlace
                ].passwordString else {
                    return .none
                }
                
                return .send(.participateRoom(stoneInfo, password))
            case let .participateRoom(stoneInfo, password):
                return .concatenate([
                    .send(.setLoading(true)),
                    .run { send in
                        await send(participateRoom(stoneInfo, password))
                    }
                ])
            case .participateCompleted(let stoneInfo):
                let dateString = state.selectedDate.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                return .concatenate([
                    .send(.setLoading(false)),
                    .send(.navigateToGameDetail(stoneInfo.gameID, stoneInfo.name, dateString))
                ])
            case .navigateToGameDetail:
                return .none
            case .sendToast:
                return .none
            }
        }
        .ifLet(\.$myGameSheet, action: \.myGameSheet) {
            MyGameSheetFeature()
        }
    }
}

private extension MyGameFeature {
    func addSingleValueToMyGameList(_ value: MyGameModel, state: inout State) {
        if let index = state.myGameList.firstIndex(where: { $0 == nil }) {
            state.myGameList[index] = value
        } else {
            state.myGameList.append(value)
        }
    }
    
    func addListValueToMyGameList(_ list: [MyGameModel], state: inout State) {
        for singleValue in list {
            addSingleValueToMyGameList(singleValue, state: &state)
        }
    }
    
    func checkAndAppendNilIfNeeded(state: inout State) {
        let minimumRequiredCount = 6
        if state.myGameList.count <= minimumRequiredCount {
            let neededCount = minimumRequiredCount - state.myGameList.count
            state.myGameList.append(contentsOf: Array(repeating: nil, count: neededCount))
        }
        
        if (state.myGameList.count > minimumRequiredCount) && (state.myGameList.count % 2 == 1) {
            state.myGameList.append(nil)
        }
    }
}

private extension MyGameFeature {
    func fetchMyGameInfo(_ dateString: String, _ isToday: Bool) async throws -> [MyGameModel] {
        let response = await gameUseCase.fetchGameInfosFromDate(dateString, isToday)
        switch response {
        case .success(let myGameModels):
            return myGameModels
        case .failure(let error):
            throw error
        }
    }
    
    func fetchNotificationBadgeStatus() async throws -> Bool {
        let response = await notificationUseCase.fetchNotificationBadgeStatus()
        switch response {
        case .success(let badgeStatus):
            return badgeStatus.hasBadge
        case .failure(let error):
            throw error
        }
    }
    
    func fetchInitialData(_ dateString: String, _ isToday: Bool) async -> Action {
        do {
            async let myGameInfoResponse = fetchMyGameInfo(dateString, isToday)
            async let notificationBadgeResponse = fetchNotificationBadgeStatus()
            
            let (myGameModels, hasNotification) = try await (
                myGameInfoResponse,
                notificationBadgeResponse
            )
            
            return .initialDataFetched(myGameModels, hasNotification)
        } catch let error as NetworkError {
            return .passError(error)
        } catch {
            return .passError(.unKnownError)
        }
    }
    
    func updateTodayOmokStatus(_ gameID: Int) async -> Action {
        let response = await gameUseCase.updateTodayGameStatus(gameID)
        
        switch response {
        case .success:
            return .omokStatusUpdated(gameID)
        case .failure(let error):
            return .passError(error)
        }
    }
    
    func participateRoom(_ stoneInfo: MyGameModel, _ password: String?) async -> Action {
        let response = await gameUseCase.participateRoom(stoneInfo.gameID, password)
        
        switch response {
        case .success(let isParticipateSuccess):
            return isParticipateSuccess
                ? .participateCompleted(stoneInfo)
                : .passAlert(.passwordError)
        case .failure(let error):
            return .passError(error)
        }
    }
    
    func validateParticipateStatus(_ stoneInfo: MyGameModel, selectedDate: Date) -> Effect<Action> {
        switch stoneInfo.participateStatus {
        case .active:
            let dateString = selectedDate.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
            return .send(.navigateToGameDetail(stoneInfo.gameID, stoneInfo.name, dateString))
        case .kicked:
            return .send(.sendToast("더 이상 참여할 수 없는 대국이에요."))
        case .left:
            return .send(.passAlert(.participateDoubleCheck(stoneInfo)))
        case .done:
            return .send(.sendToast("끝난 대국이에요"))
        }
    }
}
