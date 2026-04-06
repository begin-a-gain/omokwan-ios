//
//  Dependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by 김동준 on 8/21/24
//

import ProjectDescription

public extension Array where Element == TargetDependency {
    static func dependencies(of name: String) -> [TargetDependency] {
        guard let name = DependencyInformation(rawValue: name) else { return [] }
        guard let modules: [DependencyInformation] = dependencyInfo[name] else { return [] }
        
        return modules.map { module in
            let name = module.rawValue
            
            if externalDependency.contains(module) {
                return .external(name: name)
            } else if (PresentationDependencyInformation.allCases.map { $0.rawValue }.contains(name)) {
                return .project(target: name, path: .relativeToRoot("Projects/Presentation/\(name)"))
            } else if (UtilsDependencyInformation.allCases.map { $0.rawValue }.contains(name)) {
                return .project(target: name, path: .relativeToRoot("Projects/Utils/\(name)"))
            } else {
                return .project(target: name, path: .relativeToRoot("Projects/\(name)"))
            }
        }
    }
}
