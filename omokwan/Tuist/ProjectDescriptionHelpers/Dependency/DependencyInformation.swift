//
//  DependencyInformation.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 8/21/24
//

import Foundation

let dependencyInfo: [DependencyInformation: [DependencyInformation]] = [
    .Omokwan: [.Root, .DI, .Data, .KakaoSDKUser],
    .Domain: [.DI, .ComposableArchitecture],
    .Data: [.Domain, .KakaoSDKUser, .Util],
    .Root: [.SignIn, .SignUp, .Main],
    .SignIn: [.Base],
    .SignUp: [.Base, .Util],
    .Main: [.MyGame, .MyGameAdd, .MyGameParticipate, .GameDetail],
    .DI: [.Swinject],
    .Base: [.DesignSystem, .ComposableArchitecture, .Domain],
    .MyGame: [.Base, .Util],
    .MyGameAdd: [.Base, .Util],
    .MyGameParticipate: [.Base, .Util],
    .GameDetail: [.Base, .Util]
]

public enum DependencyInformation: String, Sendable {
    case Omokwan = "Omokwan"
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
