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
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0/StroeerSDK.xcframework.zip",
            checksum: "ac97e306a4179ac01d8936e2988a42de2fb0832fa31986ac13a701110261fad2"
        ),

        .binaryTarget(
            name: "StroeerSDK_Consent",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0/StroeerSDK_Consent.xcframework.zip",
            checksum: "2f8a4196d18c197788ea79e41d93a3bb7adfdb4bcbc97e1a678b26396ba2af62"
        ),

        .binaryTarget(
            name: "StroeerSDK_Confiant",
            url: "https://github.com/stroeersdk/iOS/releases/download/1.0.0/StroeerSDK_Confiant.xcframework.zip",
            checksum: "92718cb0354495cdde9e7248038bba0859898bba319193d35b25392e3fd459b5"
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
