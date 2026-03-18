//
//  Project+Templates.swift
//  Packages
//
//  Created by 김동준 on 8/18/24
//

import ProjectDescription

public extension Project {
    private static let environmentSettings = EnvironmentSettings.default
    private static let appName = environmentSettings.name
    private static let organizationName = environmentSettings.organizationName
    
    static let customOptions: Options = .options(
        automaticSchemesOptions: .disabled,
        disableBundleAccessors: true,
        disableSynthesizedResourceAccessors: true
    )
    
    static var app: Project {
        return Project(
            name: appName,
            organizationName: organizationName,
            options: customOptions,
            settings: .settings(
                base: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                configurations: .default
            ),
            targets: .app,
            schemes: .app,
            additionalFiles: ["../../XCConfig/Shared.xcconfig"]
        )
    }
    
    static func module(
        name: String,
        options: Options = customOptions
    ) -> Project {
        return Project(
            name: name,
            organizationName: organizationName,
            options: options,
            settings: .settings(
                base: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                configurations: .default
            ),
            targets: .targets(name: name),
            schemes: []
        )
    }
}

public extension Project {
    static let fontFamilys: [Plist.Value] = [
        .string("SUIT-Bold.otf"),
        .string("SUIT-Medium.otf"),
        .string("SUIT-Regular.otf"),
        .string("SUIT-Light.otf")
    ]
    
    static func designSystemModule(
        name: String,
        options: Options = .options()
    ) -> Project {
        let infoPlists: InfoPlist = .extendingDefault(with: ["UIAppFonts": .array(fontFamilys)])
        let implements = Target.implements(name: name, product: .staticFramework, resources: ["Resources/**"], dependencies: .dependencies(of: name), infoPlist: infoPlists)
        
        return Project(
            name: name,
            organizationName: organizationName,
            options: .options(
                automaticSchemesOptions: .disabled
            ),
            settings: .settings(configurations: .default),
            targets: [
                implements
            ],
            schemes: [],
            resourceSynthesizers: [
                .assets(),
                .fonts(),
                .custom(name: "JSON", parser: .json, extensions: ["json"])
            ]
        )
    }
}
