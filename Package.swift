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
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.3/StroeerSDK.xcframework.zip",
            checksum: "3e3548c24482cdf10cad3e30d8449af3749a96353ccc4baf06a749fdcca74657"
        ),

        .binaryTarget(
            name: "StroeerSDK_Consent",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.3/StroeerSDK_Consent.xcframework.zip",
            checksum: "b389e49f21c461bb508c73decf1282ee09cfd6b574781d75e643aa032961244a"
        ),

        .binaryTarget(
            name: "StroeerSDK_Confiant",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0-rc.3/StroeerSDK_Confiant.xcframework.zip",
            checksum: "f59da97041e1ba01ae6194f202eae26e634c5a3051ea3fd02e907c04f0ae08d9"
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
