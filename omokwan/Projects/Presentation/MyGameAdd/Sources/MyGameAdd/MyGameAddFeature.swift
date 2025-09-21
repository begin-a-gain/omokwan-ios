//
//  MyGameAddFeature.swift
//  MyGameAdd
//
//  Created by 김동준 on 11/30/24
//

import ComposableArchitecture
import Domain
import Base
import Util

@Reducer
public struct MyGameAddFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init(categories: [GameCategory], selectedCategory: GameCategory?) {
            self.cateogryList = categories
            self.selectedCategory = selectedCategory
        }
        
        // MARK: Alert
        public enum AlertCase: Equatable {
            case password
            case create
            case leave
            case error(NetworkError)
        }
        
        enum GameNameValidStatus {
            case empty
            case valid
            case inValidFormat
        }
        
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false
        
        @BindingState var gameName: String = ""
        var gameNameValidStatus: GameNameValidStatus?
        var selectedRepeatDay: MyGameAddRepeatDayType = .weekday
        var directSelectionTypeList: [MyGameAddDirectSelectionDayType] = MyGameAddDirectSelectionDayType.allCases
        var isSelectedDirectSelectionList: [Bool] = Array(repeating: false, count: MyGameAddDirectSelectionDayType.allCases.count)
        var maxNumOfPeople: Int = 5
        var cateogryList: [GameCategory] = []
        var selectedCategory: GameCategory?
        @BindingState var isRemindAlarmSelected: Bool = false
        
        @PresentationState var repeatDaySheet: MyGameRepeatDaySheetFeature.State?
        @PresentationState var maxNumOfPeopleSheet: MyGameMaxNumOfPeopleSheetFeature.State?
        @PresentationState var gameCategorySheet: MyGameCategorySheetFeature.State?
        
        // MARK: 비공개 설정
        @BindingState var isPrivateRoomSelected: Bool = false
        var privateRoomPassword: String?
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""
        
        var isStartButtonEnable: Bool {
            return isGameNameValidation
                && isDirectSelectionValidation
        }
        
        var isGameNameValidation: Bool {
            guard let gameNameValidStatus = gameNameValidStatus else {
                return false
            }
            
            return gameNameValidStatus == .valid
        }
        
        var isDirectSelectionValidation: Bool {
            if selectedRepeatDay != .directSelection {
                return true
            }
            
            return !isSelectedDirectSelectionList.allSatisfy { $0 == false }
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case navigateToBack
        case binding(BindingAction<State>)
        case repeatDayButtonTapped
        case directSelectionListButtonTapped(Int)
        case maxNumOfPeopleButtonTapped
        case gameCategorySettingButtonTapped
        case repeatDaySheet(PresentationAction<MyGameRepeatDaySheetFeature.Action>)
        case maxNumOfPeopleSheet(PresentationAction<MyGameMaxNumOfPeopleSheetFeature.Action>)
        case gameCategorySheet(PresentationAction<MyGameCategorySheetFeature.Action>)
        case privateRoomToggleButtonTapped
        case alertAction(AlertFeature.Action)
        case showAlert(State.AlertCase)
        case passwordAlertConfirmButtonTapped
        case passwordAlertCancelButtonTapped
        case privateRoomCodeButtonTapped
        case gameStartButtonTapped
        case createAlertCancelButtonTapped
        case createAlertConfirmButtonTapped
        case createRoomComplete(String)
        case backButtonTapped
        case leaveAlertCloseButtonTapped
        case leaveAlertLeaveButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .navigateToBack:
                return .none
            case .binding(\.$gameName):
                if state.gameName.isEmpty {
                    state.gameNameValidStatus = .empty
                    return .none
                }
                
                let isValid = state.gameName.checkRegexValidation(
                    pattern: RegexPattern.gameName.regex
                )
                
                state.gameNameValidStatus = isValid ? .valid : .inValidFormat
                return .none
            case .binding:
                return .none
            case .repeatDayButtonTapped:
                state.repeatDaySheet = .init(selectedRepeatDayValue: state.selectedRepeatDay)
                return .none
            case .repeatDaySheet(let action):
                switch action {
                case .presented(let presentAction):
                    switch presentAction {
                    case .selectButtonTapped(let repeatDay):
                        state.repeatDaySheet = nil
                        state.selectedRepeatDay = repeatDay
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .directSelectionListButtonTapped(let index):
                state.isSelectedDirectSelectionList[index].toggle()
                return .none
            case .maxNumOfPeopleButtonTapped:
                state.maxNumOfPeopleSheet = .init(selectedMaxNumOfPeopleCount: state.maxNumOfPeople)
                return .none
            case .maxNumOfPeopleSheet(let action):
                switch action {
                case .presented(let presentAction):
                    switch presentAction {
                    case .selectButtonTapped(let value):
                        state.maxNumOfPeopleSheet = nil
                        state.maxNumOfPeople = value
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .gameCategorySettingButtonTapped:
                state.gameCategorySheet = .init(
                    categories: state.cateogryList,
                    selectedCategory: state.selectedCategory
                )
                return .none
            case .gameCategorySheet(let action):
                switch action {
                case .presented(let presentAction):
                    switch presentAction {
                    case .selectButtonTapped(let value):
                        state.gameCategorySheet = nil
                        state.selectedCategory = value
                        return .none
                    default:
                        return .none
                    }
                default:
                    return .none
                }
            case .privateRoomToggleButtonTapped:
                if state.isPrivateRoomSelected {
                    state.isPrivateRoomSelected = false
                } else {
                    if let _ = state.privateRoomPassword {
                        state.isPrivateRoomSelected = true
                    } else {
                        return .send(.showAlert(.password))
                    }
                }
                return .none
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .passwordAlertConfirmButtonTapped:
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                state.privateRoomPassword = String(password)
                state.isPrivateRoomSelected = true
                
                return .send(.alertAction(.dismiss))
            case .passwordAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .privateRoomCodeButtonTapped:
                if let _ = state.privateRoomPassword {
                    if state.isPrivateRoomSelected {
                        return .send(.showAlert(.password))
                    }
                }
                
                return .none
            case .gameStartButtonTapped:
                return .send(.showAlert(.create))
            case .createAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .createAlertConfirmButtonTapped:
                let configuration = getCreateGameRoomRequestConfiguration(state)
                state.isLoading = true
                
                return .merge([
                    .send(.alertAction(.dismiss)),
                    .run { send in
                        await send(createRoom(configuration))
                    }
                ])
            case .createRoomComplete:
                state.isLoading = false
                return .none
            case .backButtonTapped:
                return .send(.showAlert(.leave))
            case .leaveAlertCloseButtonTapped:
                return .send(.alertAction(.dismiss))
            case .leaveAlertLeaveButtonTapped:
                return .merge([
                    .send(.alertAction(.dismiss)),
                    .send(.navigateToBack)
                ])
            }
        }
        .ifLet(\.$repeatDaySheet, action: \.repeatDaySheet) {
            MyGameRepeatDaySheetFeature()
        }
        .ifLet(\.$maxNumOfPeopleSheet, action: \.maxNumOfPeopleSheet) {
            MyGameMaxNumOfPeopleSheetFeature()
        }
        .ifLet(\.$gameCategorySheet, action: \.gameCategorySheet) {
            MyGameCategorySheetFeature()
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
    }
}

private extension MyGameAddFeature {
    func getCreateGameRoomRequestConfiguration(_ state: State) -> MyGameAddConfiguration {
        let name: String = state.gameName
        
        let dayType: [Int] = getDayTypeCode(
            selectedRepeatDay: state.selectedRepeatDay,
            directSelectionTypeList: state.directSelectionTypeList,
            isSelectedDirectSelectionList: state.isSelectedDirectSelectionList
        )
        
        let maxParticipants: Int = state.maxNumOfPeople
        let categoryCode: String? = state.selectedCategory?.code
        
        let isPublic: Bool = !state.isPrivateRoomSelected
        let password: String? = isPublic ? nil : state.privateRoomPassword
        
        return MyGameAddConfiguration(
            name: name,
            dayType: dayType,
            maxParticipants: maxParticipants,
            categoryCode: categoryCode,
            password: password,
            isPublic: isPublic
        )
    }
    
    func getDayTypeCode(
        selectedRepeatDay: MyGameAddRepeatDayType,
        directSelectionTypeList: [MyGameAddDirectSelectionDayType],
        isSelectedDirectSelectionList: [Bool]
    ) -> [Int] {
        switch selectedRepeatDay {
        case .directSelection:
            zip(directSelectionTypeList, isSelectedDirectSelectionList)
                .filter { $0.1 }
                .map { $0.0.code }
        default:
            [selectedRepeatDay.code]
        }
    }
    
    func createRoom(_ configuration: MyGameAddConfiguration) async -> Action {
        let response = await gameUseCase.createGame(configuration)
        switch response {
        case .success:
            return .createRoomComplete(configuration.name)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
