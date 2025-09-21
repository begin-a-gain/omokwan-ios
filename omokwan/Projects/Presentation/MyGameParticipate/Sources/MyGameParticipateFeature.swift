//
//  MyGameParticipateFeature.swift
//  MyGameParticipate
//
//  Created by 김동준 on 1/1/25
//

import ComposableArchitecture
import Domain
import Base

@Reducer
public struct MyGameParticipateFeature {
    @Dependency(\.gameUseCase) private var gameUseCase

    public init() {}
    
    public struct State: Equatable {
        public init() {}
        
        public enum AlertCase: Equatable {
            case error(NetworkError)
            case participateDoubleCheck(GameRoomInformation)
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
        case navigateToGameDetail(GameRoomInformation)
        
        case categoriesFetched([GameCategory])
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .alertAction:
                return .none
            case .binding:
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
                    return .none
                } else {
                    return .merge([
                        .send(.alertAction(.dismiss)),
                        .send(.navigateToGameDetail(roomInfo))
                    ])
                }
            case .navigateToGameDetail:
                return .none
            case .categoriesFetched(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            }
        }
        .ifLet(\.$categorySheet, action: \.categorySheet) {
            MyGameParticipateCategorySheetFeature()
        }
        Scope(state: \.alertState, action: \.alertAction) {
            AlertFeature()
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
