//
//  MyGameParticipateFeature.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/1/25
//

import ComposableArchitecture
import Domain
import Base
import Foundation
import Util

@Reducer
public struct MyGameParticipateFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(GameRoomInformation)
            case password
        }
        var alertCase: AlertCase?
        var alertState: AlertFeature.State = .init()
        var isLoading: Bool = false

        enum CategoryFilterType {
            case availableRoom
            case category
        }
        
        @BindingState var searchText: String = ""
        
        var isResetFilterButtonVisible: Bool {
            return isAvailableParticipateRoomSelected || isCategoryFilterSelected
        }
        
        // About Filter
        var isAvailableParticipateRoomSelected: Bool = false
        var numOfCategory: Int {
            selectedCategoryTitles.count
        }
        var isCategoryFilterSelected: Bool {
            return !selectedCategoryTitles.isEmpty
        }
        
        @PresentationState var categorySheet: MyGameParticipateCategorySheetFeature.State?
        
        var selectedCategoryTitles: [String] = []
        var gameRoomInformationList: [GameRoomInformation] = []
        var categories: [GameCategory] = []
        
        @BindingState var thousandsPlace: String = ""
        @BindingState var hundredsPlace: String = ""
        @BindingState var tensPlace: String = ""
        @BindingState var onesPlace: String = ""
    }
    
    public enum Action: BindableAction {
        case onAppear
        case binding(BindingAction<State>)
        case showAlert(State.AlertCase)

        case navigateToBack
        case resetFilterButtonTapped
        case availableParticipateRoomFilterTapped
        case categoryFilterTapped
        case searchBarClearButtonTapped
        case categorySheet(PresentationAction<MyGameParticipateCategorySheetFeature.Action>)
        case participateButtonTapped(GameRoomInformation)
        case showDoubleCheckAlert(GameRoomInformation)
        case alertAction(AlertFeature.Action)
        case alertParticipateButtonTapped(GameRoomInformation)
        case navigateToGameDetail(Int, String, String)
        
        case categoriesFetched([GameCategory])
        case passwordAlertCancelButtonTapped
        case passwordAlertConfirmButtonTapped
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
        }
        Reduce { state, action in
            switch action {
            case .alertAction:
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alertCase = alertCase
                return .send(.alertAction(.present))
            case .onAppear:
                state.gameRoomInformationList = [
                    .init(
                        title: "30분 이상 아침 달리기 하기(잠금o)",
                        isPrivateRoom: true,
                        currentNumOfPeople: 3,
                        maxNumOfPeople: 5,
                        category: .init(code: "1", category: "다이어트", emoji: ""),
                        createRoomDate: .now,
                        hostName: "빡빡이",
                        roomStatus: .available
                    ),
                    .init(
                        title: "운동하기(잠금x)",
                        isPrivateRoom: false,
                        currentNumOfPeople: 3,
                        maxNumOfPeople: 5,
                        category: .init(code: "1", category: "다이어트", emoji: ""),
                        createRoomDate: .now,
                        hostName: "오목왕빡빡이",
                        roomStatus: .available
                    ),
                    .init(
                        title: "30분",
                        isPrivateRoom: true,
                        currentNumOfPeople: 3,
                        maxNumOfPeople: 2,
                        category: .init(code: "1", category: "다이어트", emoji: ""),
                        createRoomDate: .now,
                        hostName: "ㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇㅇ",
                        roomStatus: .participating
                    ),
                    .init(
                        title: "30분 이상 아침 달리기 하기",
                        isPrivateRoom: true,
                        currentNumOfPeople: 3,
                        maxNumOfPeople: 5,
                        category: .init(code: "1", category: "다이어트", emoji: ""),
                        createRoomDate: .now,
                        hostName: "dddddddddddd",
                        roomStatus: .unavailable
                    )
                ]
                return .run { send in
                    await send(fetchCategories())
                }
            case .binding:
                return .none
            case .navigateToBack:
                return .none
            case .resetFilterButtonTapped:
                state.isAvailableParticipateRoomSelected = false
                state.selectedCategoryTitles = []
                return .none
            case .availableParticipateRoomFilterTapped:
                state.isAvailableParticipateRoomSelected.toggle()
                return .none
            case .categoryFilterTapped:
                state.categorySheet = .init(
                    categories: state.categories,
                    selectedCategoryTitles: state.selectedCategoryTitles
                )
                return .none
            case .searchBarClearButtonTapped:
                state.searchText = ""
                return .none
            case .categorySheet(let categorySheetAction):
                switch categorySheetAction {
                case .presented(let sheetAction):
                    switch sheetAction {
                    case .passSelectedCategories(let selectedCategories):
                        state.selectedCategoryTitles = selectedCategories
                        state.categorySheet = nil
                        
                        return .none
                    default:
                        return .none
                    }
                case .dismiss:
                    return .none
                }
            case .participateButtonTapped(let roomInfo):
                switch roomInfo.roomStatus {
                case .available:
                    return .send(.showDoubleCheckAlert(roomInfo))
                default:
                    return .none
                }
            case .showDoubleCheckAlert(let roomInfo):
                state.alertCase = .participateDoubleCheck(roomInfo)
                return .send(.alertAction(.present))
            case .alertParticipateButtonTapped(let roomInfo):
                if roomInfo.isPrivateRoom {
                    // TODO: 비공개코드 alert 필요
                    state.alertCase = .password
                    return .none
                } else {
                    let selectedDateString = Date.now.formattedString(format: DateFormatConstants.yearMonthDayRequestFormat)
                    return .merge([
                        .send(.alertAction(.dismiss)),
                        // TODO: 나중에 API 나오고 roomInfo modeling 변경, 넘기는 파라미터 수정
                        .send(.navigateToGameDetail(1, roomInfo.title, selectedDateString))
                    ])
                }
            case .navigateToGameDetail:
                return .none
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            case .passwordAlertCancelButtonTapped:
                return .send(.alertAction(.dismiss))
            case .passwordAlertConfirmButtonTapped:
                guard let thousands = Int(state.thousandsPlace),
                      let hundreds = Int(state.hundredsPlace),
                      let tens = Int(state.tensPlace),
                      let ones = Int(state.onesPlace)
                else { return .none }
                
                let password = (1000 * thousands) + (100 * hundreds) + (10 * tens) + ones
                
                print("password = \(password)")
                // TODO: 참여 API 호출
                
                return .send(.alertAction(.dismiss))
            }
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            MyGameParticipateCategorySheetFeature()
        }
    }
}

private extension MyGameParticipateFeature {
    func fetchCategories() async -> Action {
        let response = await gameUseCase.fetchGameCategories()
        switch response {
        case .success(let categories):
            return .categoriesFetched(categories)
        case .failure(let error):
            return .showAlert(.error(error))
        }
    }
}
