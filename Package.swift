// swift-tools-version: 5.9
// Public SwiftPM distribution for the Ezoic Ads SDK.
//
// This package contains *no* implementation code. The real
// implementation lives in a private Ezoic repository and ships here
// as a pre-built XCFramework attached to each GitHub Release. The
// URL + checksum on the `.binaryTarget` below are bumped (atomically,
// via CI) on every SDK release, the same way Maven Central artifacts
// work for the Kotlin SDK.
//
// Why two targets instead of one?
// SwiftPM's `.binaryTarget` cannot declare dependencies. The
// XCFramework's swiftinterface references `PrebidMobile` and
// `GoogleMobileAds`, so the consumer's compiler needs those modules
// on its search path. To wire that up we have a tiny source target
// (`EzoicAdsSDK`, containing one stub Swift file) that depends on
// both the binary AND the two transitive SwiftPM packages and re-
// exports the binary's public API via `@_exported import`. Consumers
// just write `import EzoicAdsSDK` — the rename to `EzoicAdsSDKBinary`
// is invisible to them. Same approach used by Google's
// swift-package-manager-google-mobile-ads dist repo.

import PackageDescription

let package = Package(
    name: "EzoicAdsSDK",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "EzoicAdsSDK",
            targets: ["EzoicAdsSDK"]
        )
    ],
    dependencies: [
        // Prebid Mobile SDK for header bidding.
        // 3.1+ gives us `setImpORTBConfig` (used by the SDK to pass
        // per-placement bidder configs through to sol's
        // /m/apps/auction endpoint) and a SwiftPM-resolvable target.
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", from: "3.1.0"),

        // Google Mobile Ads SDK.
        // Pinned to 12.x because Prebid Mobile iOS 3.1+ requires it.
        // GMA 12 dropped the GAD/GAM Swift prefixes — see
        // https://developers.google.com/admob/ios/migration#v11_to_v12.
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "12.0.0" ..< "13.0.0"
        )
    ],
    targets: [
        // Closed-source binary. Module name is `EzoicAdsSDKBinary`
        // so it doesn't collide with the wrapper target below.
        //
        // CI keeps the URL + checksum in sync with the latest
        // release; do NOT edit by hand without running
        // `Distribution/build-xcframework.sh` in the source repo and
        // re-uploading the matching zip to GitHub Releases.
        .binaryTarget(
            name: "EzoicAdsSDKBinary",
            url: "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/1.0.0-rc4/EzoicAdsSDK-1.0.0-rc4.xcframework.zip",
            checksum: "7bb95b44b45c7cd358190a9b0e6064bddf0a1a176d5ecfed9f2cb35216b9e7db"
        ),

        // Source-level wrapper that re-exports the binary and wires
        // up the transitive SwiftPM dependencies. Contains exactly one
        // Swift file: `Sources/EzoicAdsSDK/Exports.swift`, with
        // `@_exported import EzoicAdsSDKBinary`.
        .target(
            name: "EzoicAdsSDK",
            dependencies: [
                .target(name: "EzoicAdsSDKBinary"),
                .product(name: "PrebidMobile", package: "prebid-mobile-ios"),
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                )
            ],
            path: "Sources/EzoicAdsSDK"
        )
    ]
)
