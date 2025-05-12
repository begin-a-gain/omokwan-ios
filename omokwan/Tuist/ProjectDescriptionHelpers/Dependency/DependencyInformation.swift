//
//  DependencyInformation.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 8/21/24
//

import Foundation

let dependencyInfo: [DependencyInformation: [DependencyInformation]] = [
    .App: [.Root, .DI, .Data, .KakaoSDKUser],
    .Domain: [.DI, .ComposableArchitecture],
    .Data: [.Domain, .KakaoSDKUser],
    .Root: [.SignIn, .SignUp, .Main],
    .SignIn: [.Domain, .Base],
    .SignUp: [.Domain, .Base],
    .Main: [.MyGame, .MyGameAdd, .MyGameParticipate, .GameDetail],
    .DI: [.Swinject],
    .Base: [.DesignSystem, .ComposableArchitecture],
    .MyGame: [.Base, .Util, .Domain],
    .MyGameAdd: [.Base, .Util, .Domain],
    .MyGameParticipate: [.Base, .Util, .Domain],
    .GameDetail: [.Base, .Util, .Domain]
]

public enum DependencyInformation: String {
    case App = "App"
    case SignIn = "SignIn"
    case SignUp = "SignUp"
    case Domain = "Domain"
    case Data = "Data"
    case Root = "Root"
    case Main = "Main"
    case DI = "DI"
    case Swinject = "Swinject"
    case Base = "Base"
    case KakaoSDKUser = "KakaoSDKUser"
    case DesignSystem = "DesignSystem"
    case ComposableArchitecture = "ComposableArchitecture"
    case MyGame = "MyGame"
    case Util = "Util"
    case MyGameAdd = "MyGameAdd"
    case MyGameParticipate = "MyGameParticipate"
    case GameDetail = "GameDetail"
}

public enum PresentationDependencyInformation: String, CaseIterable {
    case SignIn = "SignIn"
    case SignUp = "SignUp"
    case Root = "Root"
    case Main = "Main"
    case Base = "Base"
    case MyGame = "MyGame"
    case MyGameAdd = "MyGameAdd"
    case MyGameParticipate = "MyGameParticipate"
    case GameDetail = "GameDetail"
}

public enum UtilsDependencyInformation: String, CaseIterable {
    case Util = "Util"
}
