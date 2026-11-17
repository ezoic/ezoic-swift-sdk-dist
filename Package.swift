// swift-tools-version: 5.9
// Public SwiftPM distribution for the Ezoic Ads SDK.
//
// This package contains *no* implementation code. The real
// implementation lives in a private Ezoic repository and ships here
// as three pre-built XCFrameworks attached to each GitHub Release:
//
//   - `EzoicConsentCoreBinary`: the consent types the other two share
//     (`ConsentOutcome`, `ConsentDecisionType`, `EzoicErrorCode`).
//   - `EzoicCmpSDKBinary`: the built-in CMP (imports the core). Also its own
//     product, `EzoicCmpSDK`, for apps that don't use Ezoic ads.
//   - `EzoicAdsSDKBinary`: the ads SDK (imports the core, never the CMP: it
//     finds the CMP at runtime, so apps can leave it out).
//
// The URL + checksum on each `.binaryTarget` below are bumped (in a single
// commit, alongside the GitHub Release create) on every SDK release, the
// same way Maven Central artifacts work for the Kotlin SDK. The source
// repo's release workflow + `Distribution/release-from-artifact.sh` are the
// two supported entry points for that bump.
//
// Why wrapper targets?
// SwiftPM's `.binaryTarget` cannot declare dependencies. The ads
// XCFramework's swiftinterface references `PrebidMobile`,
// `GoogleMobileAds` and `DTBiOSSDK`, so the consumer's compiler needs those
// modules on its search path. Each binary therefore has a tiny source target
// (`EzoicAdsSDK`, `EzoicCmpSDK`, `EzoicConsentCore`, each one stub Swift
// file) that depends on the binary and its dependencies and re-exports the
// binary's public API via `@_exported import`. Consumers just write
// `import EzoicAdsSDK` — the `…Binary` module names are invisible to them.
// Same approach used by Google's swift-package-manager-google-mobile-ads
// dist repo.
//
// With or without the built-in CMP
// The `EzoicAdsSDK` product links the CMP: its `EzoicAdsSDKCmpLink` target
// references the CMP's provider class, which makes the linker include the
// CMP (static archives only contribute what something references).
// `EzoicAdsSDKWithoutCMP` leaves that target, and so every byte of the CMP,
// out; the SDK then behaves as with `cmpEnabled = false`.

import PackageDescription

let package = Package(
    name: "EzoicAdsSDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // The ads SDK with the built-in TCF CMP. Most apps want this one.
        .library(
            name: "EzoicAdsSDK",
            targets: ["EzoicAdsSDK", "EzoicAdsSDKCmpLink"]
        ),
        // The ads SDK without the built-in CMP, for apps that use another CMP
        // (also set `cmpEnabled = false`). Same `import EzoicAdsSDK`; no CMP
        // code is linked. Add one of the two ads products, not both.
        .library(
            name: "EzoicAdsSDKWithoutCMP",
            targets: ["EzoicAdsSDK"]
        ),
        // The built-in TCF CMP alone, for Ezoic publishers whose app doesn't
        // use Ezoic ads. The EzoicAdsSDK product already includes it.
        .library(
            name: "EzoicCmpSDK",
            targets: ["EzoicCmpSDK"]
        )
    ],
    dependencies: [
        // Prebid Mobile SDK for header bidding.
        //
        // Pinned *exactly* to the version the binary was compiled against
        // (the source repo's Package.resolved). The XCFramework is a static
        // archive that does not carry its own copy of Prebid; it links the
        // consumer's. PrebidMobile is a Swift module built without library
        // evolution, so a different minor/patch can break the link
        // ("Undefined symbol … PrebidMobile.…") or, worse, change type
        // layouts silently. The release pipeline bumps this alongside the
        // binaryTarget below whenever the source repo's resolved version
        // changes. prebid-mobile-ios-sdk is Prebid's SwiftPM package (same
        // sources and tags as prebid-mobile-ios); an app that depends on
        // Prebid directly must use this URL too, or SwiftPM sees two
        // `PrebidMobile` targets.
        .package(url: "https://github.com/prebid/prebid-mobile-ios-sdk.git", exact: "3.4.1"),

        // Google Mobile Ads SDK.
        // 13.x: the binary is compiled against GMA 13, and Prebid Mobile
        // iOS 3.4+ declares GMA up to the next major from 13.0.0. GMA 13.4+
        // needs Xcode 26.2 — see
        // https://developers.google.com/admob/ios/migration#migrate-to-sdk-v13.
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            "13.0.0" ..< "14.0.0"
        ),

        // Amazon Publisher Services (APS / TAM). The XCFramework's
        // swiftinterface references `DTBiOSSDK`, so the wrapper target
        // below pulls it onto the consumer's search path through Amazon's
        // official package (product AmazonPublisherServicesSDK). Exact
        // 5.6.6 to match the version the binary was compiled against.
        .package(url: "https://github.com/amzn/swift-package-manager-amazon-aps.git", exact: "5.6.6")
    ],
    targets: [
        // Closed-source binaries. Module names end in `Binary` so they don't
        // collide with the wrapper targets. The URL + checksum of each are
        // bumped by the source repo's release pipeline
        // (`.github/workflows/release-xcframework.yml`, or
        // `Distribution/release-from-artifact.sh` as the manual fallback,
        // both through `Distribution/bump-dist-manifest.sh`) to stay in
        // lock-step with the published GitHub Release on this repo. Do NOT
        // edit by hand: a checksum mismatch breaks every consumer's SwiftPM
        // resolution.

        // The consent core. No dependencies.
        .binaryTarget(
            name: "EzoicConsentCoreBinary",
            url: "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/1.24.0/EzoicConsentCore-1.24.0.xcframework.zip",
            checksum: "422bef491166ec8eb1a7c208f17978a515b5b238e505634ca32d7103160d9edc"
        ),

        // The built-in CMP. Imports the core.
        .binaryTarget(
            name: "EzoicCmpSDKBinary",
            url: "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/1.24.0/EzoicCmpSDK-1.24.0.xcframework.zip",
            checksum: "e1810dad1dba4965a68ee4be52d093a679ba9a023604498a8d2853e2c31f9e1a"
        ),

        // The ads SDK. Imports the core; never the CMP.
        .binaryTarget(
            name: "EzoicAdsSDKBinary",
            url: "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/1.24.0/EzoicAdsSDK-1.24.0.xcframework.zip",
            checksum: "d3bd51c37c23f0adc0fd2036777591d4401336b6226e1964562586f8034d6f0a"
        ),

        // Wrapper for the core. One Swift file:
        // `Sources/EzoicConsentCore/Exports.swift`, with
        // `@_exported import EzoicConsentCoreBinary`.
        .target(
            name: "EzoicConsentCore",
            dependencies: [
                .target(name: "EzoicConsentCoreBinary")
            ],
            path: "Sources/EzoicConsentCore"
        ),

        // Wrapper for the CMP. One Swift file:
        // `Sources/EzoicCmpSDK/Exports.swift`, with
        // `@_exported import EzoicCmpSDKBinary`.
        .target(
            name: "EzoicCmpSDK",
            dependencies: [
                .target(name: "EzoicCmpSDKBinary"),
                .target(name: "EzoicConsentCore")
            ],
            path: "Sources/EzoicCmpSDK"
        ),

        // Wrapper for the ads SDK: re-exports the binary and wires up its
        // transitive SwiftPM dependencies. One Swift file:
        // `Sources/EzoicAdsSDK/Exports.swift`, with
        // `@_exported import EzoicAdsSDKBinary`. No CMP dependency.
        .target(
            name: "EzoicAdsSDK",
            dependencies: [
                .target(name: "EzoicAdsSDKBinary"),
                .target(name: "EzoicConsentCore"),
                .product(name: "PrebidMobile", package: "prebid-mobile-ios-sdk"),
                .product(
                    name: "GoogleMobileAds",
                    package: "swift-package-manager-google-mobile-ads"
                ),
                .product(
                    name: "AmazonPublisherServicesSDK",
                    package: "swift-package-manager-amazon-aps"
                )
            ],
            path: "Sources/EzoicAdsSDK"
        ),

        // Links the built-in CMP into apps that use the `EzoicAdsSDK`
        // product. One Swift file, `Sources/EzoicAdsSDKCmpLink/CmpLink.swift`,
        // that references the CMP's provider class.
        .target(
            name: "EzoicAdsSDKCmpLink",
            dependencies: [
                .target(name: "EzoicAdsSDK"),
                .target(name: "EzoicCmpSDK")
            ],
            path: "Sources/EzoicAdsSDKCmpLink"
        )
    ]
)
