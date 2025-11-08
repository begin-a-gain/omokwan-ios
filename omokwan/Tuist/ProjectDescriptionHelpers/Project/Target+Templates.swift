//
//  Target+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 8/21/24
//

import ProjectDescription

extension Array where Element == Target {
    static var app: [Target] {
        let name = EnvironmentSettings.default.name
        return [
            Target.app(name: name, dependencies: .dependencies(of: name))
        ]
    }
    
    static func targets(name: String) -> [Target] {
        let implements = Target.implements(name: name, product: .staticLibrary, dependencies: .dependencies(of: name))
        
        return [implements]
    }
}

public extension Target {
    private static let environmentSettings = EnvironmentSettings.default
    private static let organizationName = environmentSettings.organizationName
    private static let destinations = environmentSettings.destinations
    private static let deploymentTargets = environmentSettings.deploymentTargets
    
    static func app(
        name: String,
        dependencies: [TargetDependency]
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "${BUNDLE_IDENTIFIER}",
            deploymentTargets: deploymentTargets,
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "App.entitlements",
            dependencies: dependencies,
            settings: .settings(configurations: .default)
        )
    }
    
    static func implements(
        name: String,
        product: Product,
        resources: ResourceFileElements? = nil,
        dependencies: [TargetDependency],
        infoPlist: InfoPlist = .default
    ) -> Target {
        return Target.target(
            name: name,
            destinations: destinations,
            product: product,
            bundleId: "com.\(organizationName).\(name.lowercased())",
            deploymentTargets: deploymentTargets,
            infoPlist: infoPlist,
            sources: ["Sources/**"],
            resources: resources,
            dependencies: dependencies,
            settings: .settings(configurations: .default)
        )
    }
}
