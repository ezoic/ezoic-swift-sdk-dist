# Ezoic Ads SDK for iOS

The official Swift Package Manager distribution for the Ezoic Ads SDK.
This repository contains the SwiftPM manifest and the pre-built
`EzoicAdsSDK.xcframework` binary releases — the source code lives in a
private Ezoic repository.

For Android / Kotlin, the equivalent distribution lives on Maven
Central as `com.ezoic.sdk:ezoic-ads-sdk`.

## Requirements

- iOS 14.0 or later
- Xcode 15.0 or later (the framework was built with
  `BUILD_LIBRARY_FOR_DISTRIBUTION=YES`, so module-stable across
  consumer Swift versions)
- Swift 5.9 or later

## Installation

### Swift Package Manager (Xcode)

1. In Xcode: **File → Add Package Dependencies…**
2. Enter the URL:
   ```
   https://github.com/ezoic/ezoic-swift-sdk-dist.git
   ```
3. Pick the version. For pre-releases use **Exact Version**; for
   stable releases use **Up to Next Major Version**.
4. Add the `EzoicAdsSDK` library to your app target.

Xcode resolves two transitive packages alongside `EzoicAdsSDK`:

- `prebid-mobile-ios` (3.1.0+) for header bidding
- `swift-package-manager-google-mobile-ads` (12.x) for GAM

### Swift Package Manager (Package.swift)

```swift
dependencies: [
    .package(
        url: "https://github.com/ezoic/ezoic-swift-sdk-dist.git",
        exact: "1.0.0-rc5"
    )
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "EzoicAdsSDK", package: "ezoic-swift-sdk-dist")
        ]
    )
]
```

## Quick start

```swift
import EzoicAdsSDK

@main
struct MyApp: App {
    init() {
        let configuration = EzoicConfiguration(
            domain: "example.com",
            debugEnabled: true
        )

        EzoicAds.shared.initialize(configuration: configuration) { result in
            switch result {
            case .success:
                print("Ezoic Ads SDK initialized")
            case .failure(let error):
                print("Ezoic Ads SDK init failed: \(error)")
            }
        }
    }

    var body: some Scene { /* … */ }
}
```

To render a banner, attach an `EzoicBannerView` to a view controller
and call `loadAd(adUnitIdentifier:)` with the integer placement ID
provided to you by Ezoic:

```swift
let banner = EzoicBannerView()
banner.loadAd(adUnitIdentifier: 101)
view.addSubview(banner)
```

## Info.plist

You must add your Google Mobile Ads App ID to your app's `Info.plist`,
the same way you do for any GMA integration:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
```

For App Tracking Transparency (recommended) also add:

```xml
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

## Versioning

Versions in this repo mirror the underlying SDK version (e.g.,
`1.0.0-rc5`). Stable releases (`1.0.0`, `1.1.0`, …) follow
[semantic versioning](https://semver.org). Pre-release tags
(`1.0.0-rc1`, `1.0.0-rc2`, …) carry the same parity contract as the
Kotlin SDK release candidates on Maven Central.

## Support

Contact your Ezoic account representative for integration support.

## License

Proprietary — see https://www.ezoic.com/terms.
