//
//  Environment.swift
//  Packages
//
//  Created by 김동준 on 8/18/24
//

import ProjectDescription

public struct EnvironmentSettings : Sendable{
    public let name: String
    public let organizationName: String
    public let deploymentTargets: DeploymentTargets
    public let platform: Platform
    public let destinations: Destinations
    
    public static let `default` = EnvironmentSettings(
        name: "Omokwan",
        organizationName: "begin-a-gain",
        deploymentTargets: .iOS("17.0"),
        platform: .iOS,
        destinations: [.iPhone]
    )
}
