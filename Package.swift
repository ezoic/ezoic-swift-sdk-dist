// swift-tools-version: 5.9
// Public SwiftPM distribution for the Ezoic Ads SDK.
//
// This package contains *no* source code. The real implementation lives
// in a private Ezoic repository and ships here as a pre-built
// XCFramework attached to each GitHub Release. The version of the
// `.binaryTarget` URL below is bumped (with a matching checksum)
// every time a new SDK release is cut, in the same way that
// Maven Central artifacts work for the Kotlin SDK.

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
        // 3.1+ added a SwiftPM-resolvable target layout and gives us
        // `setImpORTBConfig`, the impression-level OpenRTB API that
        // EzoicAdsSDK relies on to pass per-placement bidder configs
        // through to sol's `/m/apps/auction` endpoint.
        .package(url: "https://github.com/prebid/prebid-mobile-ios.git", from: "3.1.0"),

        // Google Mobile Ads SDK (GAM).
        // Pinned to 12.x because Prebid Mobile iOS 3.1+ requires it.
        // GMA 12 dropped the GAD/GAM Swift prefixes — see
        // https://developers.google.com/admob/ios/migration#v11_to_v12.
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "12.0.0" ..< "13.0.0"
        )
    ],
    targets: [
        // Binary target.
        //
        // The URL points at a GitHub Release asset on THIS repo. Each
        // SDK release uploads a new XCFramework zip and tags the
        // matching dist version. The checksum is the SHA-256 of the
        // zip, computed by `swift package compute-checksum`.
        //
        // CI keeps the URL + checksum in sync with the latest release;
        // do NOT edit by hand without running
        // `Distribution/build-xcframework.sh` in the source repo.
        .binaryTarget(
            name: "EzoicAdsSDK",
            url: "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/1.0.0-rc4/EzoicAdsSDK-1.0.0-rc4.xcframework.zip",
            checksum: "ff38d3810ba127740c274ff92d77450b6f533285008644c2dbf78638ae59168b"
        )
    ]
)
