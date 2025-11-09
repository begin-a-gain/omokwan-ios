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
            resources: [
                .glob(pattern: "Resources/**", excluding: ["Resources/Firebase/GoogleService-Info*.plist"])
            ],
            entitlements: "App.entitlements",
            scripts: [
                .pre(
                    script: "Scripts/select_google_service_info.sh",
                    name: "Select GoogleService-Info.plist",
                    basedOnDependencyAnalysis: false
                ),
                .post(
                    script: """
                    CRASHLYTICS_SCRIPT="${SRCROOT}/../../.build/checkouts/firebase-ios-sdk/Crashlytics/run"
                    if [ ! -f "$CRASHLYTICS_SCRIPT" ]; then
                        echo "❌ [Crashlytics] Script not found at: $CRASHLYTICS_SCRIPT"
                        echo "Please run 'tuist install' to download dependencies"
                        exit 1
                    fi
                    echo "📤 [Crashlytics] Uploading dSYM..."
                    "$CRASHLYTICS_SCRIPT"
                    echo "✅ [Crashlytics] Upload complete"
                    """,
                    name: "Upload dSYM to Crashlytics",
                    inputPaths: [
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
                        "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
                        "$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)"
                    ],
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: dependencies,
            settings: .settings(
                base: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                configurations: .default
            ),
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
            settings: .settings(
                base: ["DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"],
                configurations: .default
            ),
        )
    }
}
