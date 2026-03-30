//
//  GameDetailSettingFeature.swift
//  GameDetail
//
//  Created by 김동준 on 5/17/25
//

import ComposableArchitecture
import Domain
import Foundation
import Util
import Base

@Reducer
public struct GameDetailSettingFeature {
    @Dependency(\.gameUseCase) private var gameUseCase
    @Dependency(\.featureFlagUseCase) private var featureFlagUseCase
    @Dependency(\.analyticsUseCase) private var analyticsUseCase

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
            case password
            case exit
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        @BindingState var gameTitle: String = ""
        var gameTitleValidStatus: GameNameValidStatus?
        var isReminderSettingHidden: Bool = false

        var selectedCategory: GameCategory?
        var categories: [GameCategory] = []
        
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""

        let gameID: Int
        var gameUserInfos: [GameUserInfo]
        
        var originalConfiguration: GameDetailSettingConfiguration = .init()
        var currentConfiguration: GameDetailSettingConfiguration = .init()
        
        @PresentationState var maxNumOfPeopleSheet: CommonMaxNumOfPeopleFeature.State?
        @PresentationState var categorySheet: CommonCategoryFeature.State?
        @Shared(.userInfo) var userInfo = UserInfo()

        var isHost: Bool {
            let hostUser = gameUserInfos.first { $0.isHost }
            return hostUser?.userID == userInfo.id
        }
        
        var isSaveButtonEnable: Bool {
            let isConfigurationChanged = currentConfiguration != originalConfiguration
            return isConfigurationChanged && gameTitleValidStatus == .valid
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case binding(BindingAction<State>)
        case gameCodeButtonTapped
        case maxNumOfPeopleButtonTapped
        case gameCategorySettingButtonTapped
        case privateRoomCodeButtonTapped
        case privateRoomButtonAction
        case privateRoomToggleButtonTapped
        case inviteButtonTapped
        case hostChangeButtonTapped
        case navigateToHostChange(Int, [GameUserInfo])
        case navigateToInvitation(Int, [GameUserInfo], Int)
        case exitButtonTapped
        case maxNumOfPeopleSheet(PresentationAction<CommonMaxNumOfPeopleFeature.Action>)
        case categorySheet(PresentationAction<CommonCategoryFeature.Action>)
        case passwordAlertConfirmButtonTapped
        case updateGameUserInfos([GameUserInfo])
        case configurationFetched(GameDetailSettingConfiguration)
        case initialDataFetched([GameCategory], GameDetailSettingConfiguration)
        case saveButtonTapped
        case saveCompleted
        case exitAlertButtonTapped
        case exitRoom
        case exitCompleted
        case sendCopyToast(String)
        case sendSaveToast(String)
        case sendExitToast(String)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }

        Reduce { state, action in
            switch action {
            case .onAppear:
                let gameID = state.gameID
                state.isReminderSettingHidden = !featureFlagUseCase.isNotificationFlagEnabled()
                
                state.isLoading = true
                if state.categories.isEmpty {
                    return .run { send in
                        await send(fetchInitialData(gameID))
                    }
                } else {
                    return .run { send in
                        do {
                            let configuration = try await fetchSettingConfiguration(gameID)
                            await send(.configurationFetched(configuration))
                        } catch let error as NetworkError {
                            await send(.showAlert(.error(error)))
                        }
                    }
                }
            case .navigateToBack:
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .binding(\.$gameTitle):
                state.currentConfiguration.title = state.gameTitle
                if state.gameTitle.isEmpty {
                    state.gameTitleValidStatus = .empty
                    return .none
                }
                
                let isValid = state.gameTitle.checkRegexValidation(
                    pattern: RegexPattern.gameTitle.regex
                )
                
                state.gameTitleValidStatus = isValid ? .valid : .inValidFormat
                return .none
            case .binding:
                return .none
            case .gameCodeButtonTapped:
                return .send(.sendCopyToast("클립보드에 복사되었어요."))
            case .maxNumOfPeopleButtonTapped:
                state.maxNumOfPeopleSheet = .init(
                    selectedMaxNumOfPeopleCount: state.currentConfiguration.maxNumberOfPlayers
                )
                return .none
            case .privateRoomCodeButtonTapped:
                if let _ = state.currentConfiguration.password {
                    if !state.currentConfiguration.isPublic {
                        return .send(.showAlert(.password))
                    }
                }
                
                return .none
            case .privateRoomButtonAction:
                if state.isHost {
                    return .send(.privateRoomToggleButtonTapped)
                } else {
                    if !state.currentConfiguration.isPublic {
                        // TODO: 클립보드에 복사됐습니다 토스트
                    }
                    return .none
                }
            case .privateRoomToggleButtonTapped:
                if !state.currentConfiguration.isPublic {
                    state.currentConfiguration.isPublic = true
                } else {
                    if let _ = state.currentConfiguration.password {
                        state.currentConfiguration.isPublic = false
                    } else {
                        return .send(.showAlert(.password))
                    }
                }
                return .none
            case .inviteButtonTapped:
                return .send(
                    .navigateToInvitation(
                        state.gameID,
                        state.gameUserInfos,
                        state.currentConfiguration.maxNumberOfPlayers
                    )
                )
            case .hostChangeButtonTapped:
                let gameID = state.gameID
                let gameUserInfos = state.gameUserInfos
                return .send(.navigateToHostChange(gameID, gameUserInfos))
            case .navigateToHostChange:
                return .none
            case .navigateToInvitation:
                return .none
            case .exitButtonTapped:
                return .send(.showAlert(.exit))
            case .maxNumOfPeopleSheet(.presented(let presentAction)):
                switch presentAction {
                case .selectButtonTapped(let value):
                    state.maxNumOfPeopleSheet = nil
                    state.currentConfiguration.maxNumberOfPlayers = value
                    return .none
                default:
                    return .none
                }
            case .maxNumOfPeopleSheet(.dismiss):
                return .none
            case .passwordAlertConfirmButtonTapped:
                guard let password = [
                    state.thousandsPlace,
                    state.hundredsPlace,
                    state.tensPlace,
                    state.onesPlace
                ].passwordString else {
                    return .none
                }
                
                state.currentConfiguration.password = password
                state.currentConfiguration.isPublic = false
                
                return .send(.alertAction(.dismiss))
            case .gameCategorySettingButtonTapped:
                state.categorySheet = .init(
                    categories: state.categories,
                    selectedCategory: state.selectedCategory
                )
                return .none
            case .categorySheet(.presented(let presentAction)):
                switch presentAction {
                case .selectButtonTapped(let value):
                    state.categorySheet = nil
                    state.selectedCategory = value
                    guard let categoryCode = state.selectedCategory?.code else { return .none }
                    state.currentConfiguration.categoryCode = categoryCode
                    return .none
                default:
                    return .none
                }
            case .categorySheet(.dismiss):
                return .none
            case .updateGameUserInfos(let infos):
                state.gameUserInfos = infos
                return .none
            case .configurationFetched(let configuration):
                state.isLoading = false
                setConfiguration(
                    state: &state,
                    configuration: configuration
                )
                return .none
            case let .initialDataFetched(categories, configuration):
                state.isLoading = false
                state.categories = categories
                setConfiguration(
                    state: &state,
                    configuration: configuration
                )
                return .none
            case .saveButtonTapped:
                state.isLoading = true
                let gameID = state.gameID
                let request = makeUpdateRequest(state.currentConfiguration)
                return .run { send in
                    await send(updateGameDetailSetting(gameID, request))
                }
            case .saveCompleted:
                state.isLoading = false
                return .send(.sendSaveToast("대국 정보가 변경되었어요."))
            case .exitAlertButtonTapped:
                state.alertCase = nil
                
                let isMultipleUsers = state.gameUserInfos.count > 1
                let isHost = state.gameUserInfos.first?.isHost == true

                if isMultipleUsers && isHost {
                    return .send(.hostChangeButtonTapped)
                }

                return .send(.exitRoom)
            case .exitRoom:
                state.isLoading = true
                let gameID = state.gameID
                return .run { send in
                    await send(exitRoom(gameID))
                }
            case .exitCompleted:
                state.isLoading = false
                analyticsUseCase.track(.gameSelfExit)
                let title = state.gameTitle
                return .send(.sendExitToast("‘\(title)’에서 나왔어요. 다음에 다시 도전해 보세요!"))
            case .sendCopyToast:
                return .none
            case .sendSaveToast:
                return .none
            case .sendExitToast:
                return .none
            }
        }
        .ifLet(\.$maxNumOfPeopleSheet, action: \.maxNumOfPeopleSheet) {
            CommonMaxNumOfPeopleFeature()
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            CommonCategoryFeature()
        }
    }
}

private extension GameDetailSettingFeature {
    func fetchCategories() async throws -> [GameCategory] {
        let response = await gameUseCase.fetchGameCategories()
        switch response {
        case .success(let categories):
            return categories
        case .failure(let error):
            throw error
        }
    }
    
    func fetchSettingConfiguration(_ gameID: Int) async throws -> GameDetailSettingConfiguration {
        let response = await gameUseCase.fetchGameDetailSetting(gameID)
        switch response {
        case .success(let configuration):
            return configuration
        case .failure(let error):
            throw error
        }
    }
    
    func fetchInitialData(_ gameID: Int) async -> Action {
        do {
            async let categoryResponse = fetchCategories()
            async let settingResponse = fetchSettingConfiguration(gameID)

            let (category, setting) = try await (categoryResponse, settingResponse)
            
            return .initialDataFetched(category, setting)
        } catch let error as NetworkError {
            return .showAlert(.error(error))
        } catch {
            return .showAlert(.error(.unKnownError))
        }
    }
    
    func exitRoom(_ gameID: Int) async -> Action {
        let response = await gameUseCase.exitGame(gameID)
        switch response {
        case .success:
            return .exitCompleted
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
    
    func updateGameDetailSetting(
        _ gameID: Int,
        _ request: GameDetailSettingRequestDTO
    ) async -> Action {
        let response = await gameUseCase.updateGameDetailSetting(gameID, request)
        
        switch response {
        case .success:
            return .saveCompleted
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}

private extension GameDetailSettingFeature {
    func setConfiguration(
        state: inout State,
        configuration: GameDetailSettingConfiguration
    ) {
        state.originalConfiguration = configuration
        state.currentConfiguration = configuration
        
        state.gameTitle = configuration.title
        state.gameTitleValidStatus = .valid
        state.selectedCategory = state.categories.find(
            for: Int(configuration.categoryCode) ?? -1
        )
    }
    
    func makeUpdateRequest(_ config: GameDetailSettingConfiguration) -> GameDetailSettingRequestDTO {
        GameDetailSettingRequestDTO(
            name: config.title,
            maxParticipants: config.maxNumberOfPlayers,
            category: config.categoryCode.isEmpty ? nil : config.categoryCode,
            password: config.isPublic ? nil : config.password,
            isPublic: config.isPublic
        )
    }
}
