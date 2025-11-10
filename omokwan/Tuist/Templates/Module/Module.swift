//
//  Module.swift
//  Packages
//
//  Created by 김동준 on 8/18/24
//

import ProjectDescription

private let moduleNameAttribute = Template.Attribute.required("name")
private let path = "Projects/\(moduleNameAttribute)"

private let projectContents = """
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(name: \"\(moduleNameAttribute)\")
"""

private let template = Template(
    description: "A template for a new module",
    attributes: [moduleNameAttribute],
    items: [
        .string(
            path: "\(path)/Project.swift",
            contents: projectContents
        ),
        .string(
            path: "\(path)/Sources/DefaultSourceCode.swift",
            contents: "// default source code"
        )
    ]
)
