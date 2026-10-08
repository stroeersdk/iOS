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
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.6/StroeerSDK.xcframework.zip",
            checksum: "f0d772d0549f7c0cec3c987985bc08987ab704aef865f0b5851b70ca26cba84a"
        ),

        .binaryTarget(
            name: "StroeerSDK_Consent",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.6/StroeerSDK_Consent.xcframework.zip",
            checksum: "d3cc076d3b0d7030f15b36ac9bdde7f00bf986e423601b7a7fd8ad1c68678145"
        ),

        .binaryTarget(
            name: "StroeerSDK_Confiant",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.6/StroeerSDK_Confiant.xcframework.zip",
            checksum: "ea7a4aa558aa6bc1ab33c8fc5d3e9043d482b7b615627db3616644f813151458"
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
