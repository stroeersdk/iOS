// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "StroeerSDK",

    platforms: [
        .iOS(.v15)
    ],

    products: [
        .library(
            name: "StroeerSDK",
            targets: [
                "StroeerSDK",
                "CoreSupport"
            ]
        ),

        .library(
            name: "StroeerSDK_Consent",
            targets: [
                "StroeerSDK",
                "StroeerSDK_Consent",
                "CoreSupport",
                "ConsentSupport"
            ]
        ),

        .library(
            name: "StroeerSDK_Confiant",
            targets: [
                "StroeerSDK",
                "StroeerSDK_Confiant",
                "CoreSupport",
                "ConfiantSupport"
            ]
        )
    ],

    dependencies: [
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            exact: "13.7.0"
        ),

        .package(
            url: "https://github.com/SourcePointUSA/ios-cmp-app.git",
            exact: "7.12.10"
        )
    ],

    targets: [
        .binaryTarget(
            name: "StroeerSDK",
            url: "https://github.com/stroeersdk/iOS/releases/download/0.0.1/StroeerSDK.xcframework.zip",
            checksum: "da8304cac516c72a94e32d6433280e25e23675e064331e7852aeb05e404c10c4"
        ),

        .binaryTarget(
            name: "StroeerSDK_Consent",
            url: "https://github.com/stroeersdk/iOS/releases/download/0.0.1/StroeerSDK_Consent.xcframework.zip",
            checksum: "3723a8560eb5c70c289d9c11227a411a2db45d9bec4a4de4823ffaeadf27065d"
        ),

        .binaryTarget(
            name: "StroeerSDK_Confiant",
            url: "https://github.com/stroeersdk/iOS/releases/download/0.0.1/StroeerSDK_Confiant.xcframework.zip",
            checksum: "cde50d4c1734d094ac73cdb2496e9f745edfefbc7235bc7e3f938028dd06812a"
        ),

        .binaryTarget(
            name: "XCPrebidMobile",
            path: "Frameworks/XCPrebidMobile.xcframework"
        ),

        .binaryTarget(
            name: "OMSDK_Prebidorg",
            path: "Frameworks/OMSDK_Prebidorg.xcframework"
        ),

        .target(
            name: "CoreSupport",
            dependencies: [
                "StroeerSDK",
                "XCPrebidMobile",
                "OMSDK_Prebidorg",
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "Sources/Core",
            sources: ["Shim.swift"]
        ),

        .target(
            name: "ConsentSupport",
            dependencies: [
                "StroeerSDK",
                "StroeerSDK_Consent",
                "CoreSupport",
                .product(
                    name: "ConsentViewController",
                    package: "ios-cmp-app"
                )
            ],
            path: "Sources/Consent",
            sources: ["Shim.swift"]
        ),

        .target(
            name: "ConfiantSupport",
            dependencies: [
                "StroeerSDK",
                "StroeerSDK_Confiant",
                "CoreSupport"
            ],
            path: "Sources/Confiant",
            sources: ["Shim.swift"]
        )
    ]
)
