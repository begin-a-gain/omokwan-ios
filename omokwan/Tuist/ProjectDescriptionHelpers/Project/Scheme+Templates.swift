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
        let deployTargets: [Environment] = .all
        
        return deployTargets.map {
            return .scheme(
                schemeName: "\(name)-\($0.name.uppercased())",
                targetName: name,
                configurationName: .init(stringLiteral: $0.name)
            )
        }
    }
}

extension Scheme {
    static func scheme(
        schemeName: String,
        targetName: String,
        configurationName: ConfigurationName
    ) -> Scheme {
        let isProd = configurationName == .prod
        return Scheme.scheme(
            name: schemeName,
            buildAction: .buildAction(targets: ["\(targetName)"]),
            runAction: .runAction(configuration: configurationName),
            archiveAction: .archiveAction(configuration: isProd ? .release : configurationName),
            profileAction: .profileAction(configuration: isProd ? .release : configurationName),
            analyzeAction: .analyzeAction(configuration: configurationName)
        )
    }
}
