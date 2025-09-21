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

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        @BindingState var selectedDate: Date = .now
        @PresentationState var myGameSheet: MyGameSheetFeature.State?
        
        var isDatePickerVisible: Bool = false
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
        case bellButtonTapped
        case myGameSheet(PresentationAction<MyGameSheetFeature.Action>)
        case gameCreated(String)
        case gameInfoFetched([MyGameModel])
        case noAction
        case setLoading(Bool)
        case fetchGameInfo
        case passError(NetworkError)
        case stoneTapped(MyGameModel)
        case navigateToGameDetail(Int, String)
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
                        await send(fetchMyGameInfo(dateString, isToday))
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
                // 임시 로직
                let randomValue: Int = Int.random(in: 0...2)
                var myGameCompleteStatus: MyGameCompleteStatus = .complete
                if randomValue == 0 {
                    myGameCompleteStatus = .complete
                } else if randomValue == 1 {
                    myGameCompleteStatus = .inComplete
                } else {
                    myGameCompleteStatus = .inCompleteWithSkip
                }
                addSingleValueToMyGameList(
                    MyGameModel(
                        gameID: 1,
                        name: "",
                        onGoingDays: 1,
                        participants: 1,
                        maxParticipants: 1,
                        myGameCompleteStatus: myGameCompleteStatus,
                        isPrivateRoom: true
                    ),
                    state: &state
                )
                
                checkAndAppendNilIfNeeded(state: &state)
                return .none
            case .gameCreated(let title):
                // TODO: 대국 생성 완료 토스트 생성
                print("DONGJUN -> \(title) 생성 완료")
                return .none
            case .gameInfoFetched(let myGameModels):
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
                // TODO: 추방 당한, 셀프로 나간, 끝난 대국에 대한 API가 나오면 그 때 세부 작업. 현재는 detail로 이동만.
                return .send(.navigateToGameDetail(stoneInfo.gameID, stoneInfo.name))
            case .navigateToGameDetail:
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
    func fetchMyGameInfo(_ dateString: String, _ isToday: Bool) async -> Action {
        let response = await gameUseCase.fetchGameInfosFromDate(dateString, isToday)
        switch response {
        case .success(let myGameModels):
            return .gameInfoFetched(myGameModels)
        case .failure(let error):
            return .passError(error)
        }
    }
}
