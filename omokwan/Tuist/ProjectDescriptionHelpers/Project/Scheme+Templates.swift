//
//  Scheme+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 8/21/24
//

import ProjectDescription

extension Array where Element == Scheme {
    static var app: [Scheme] {
        let name = EnvironmentSettings.default.name
        let deployTargets: [ConfigurationName] = [.debug, .release]
        
        return deployTargets.map {
            return .scheme(
                schemeName: "\(name)-\($0.rawValue)",
                targetName: name,
                configurationName: .configuration($0.rawValue),
                isAppTarget: true
            )
        }
    }
}

extension Scheme {
    static func scheme(
        schemeName: String,
        targetName: String,
        configurationName: ConfigurationName,
        isAppTarget: Bool = false
    ) -> Scheme {
        let isRelease = configurationName == .release
        return Scheme.scheme(
            name: schemeName,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            runAction: .runAction(configuration: configurationName),
            archiveAction: .archiveAction(configuration: isRelease ? .release : configurationName),
            profileAction: .profileAction(configuration: isRelease ? .release : configurationName),
            analyzeAction: .analyzeAction(configuration: configurationName)
        )
    }
}
