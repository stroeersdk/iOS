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
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.1/StroeerSDK.xcframework.zip",
            checksum: "39bc2098b3eff732a168d94d35084231e88b37175757a513c796596a0b9d1a1f"
        ),

        .binaryTarget(
            name: "StroeerSDK_Consent",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.1/StroeerSDK_Consent.xcframework.zip",
            checksum: "770cf44426332efe97d9c2c5fc3b1494b16a3ab928e14b82c7c757d174d0c5a1"
        ),

        .binaryTarget(
            name: "StroeerSDK_Confiant",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.1/StroeerSDK_Confiant.xcframework.zip",
            checksum: "76b67fdac1e3864d5c9ab4deb68b6e142e4398cb4125470c306292161c084581"
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
