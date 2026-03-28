// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription
@preconcurrency import ProjectDescriptionHelpers

    let packageSettings = PackageSettings(
        productTypes: [:],
        baseSettings: .settings(configurations: .default)
    )
#endif

let package = Package(
    name: "Omokwan",
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.20.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.18.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "12.5.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.6.0")
    ]
)
