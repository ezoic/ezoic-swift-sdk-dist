# Ezoic Ads SDK for iOS

The official Swift Package Manager distribution for the Ezoic Ads SDK.
This repository contains the SwiftPM manifest and the pre-built
XCFramework binary releases (`EzoicConsentCore`, `EzoicCmpSDK` and
`EzoicAdsSDK`) — the source code lives in a private Ezoic repository.

For Android / Kotlin, the equivalent distribution lives on Maven
Central as `com.ezoic.sdk:ezoic-ads-sdk`.

## Requirements

- iOS 15.0 or later (Xcode 27 enforces a 15.0 floor; the SDK is built with Xcode 26.6 and verified against Xcode 27)
- Xcode 26.2 or later (the framework is built with Xcode 26.6 and
  `BUILD_LIBRARY_FOR_DISTRIBUTION=YES`, so it is module-stable across
  consumer Swift versions from 6.2 on; Xcode 27 is verified in CI)
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
4. Add **one** library to your app target:

| Product | What it is |
|---|---|
| `EzoicAdsSDK` | The ads SDK with the built-in CMP. Most apps want this one. |
| `EzoicAdsSDKWithoutCMP` | The ads SDK without the built-in CMP, for apps that use another CMP (also set `cmpEnabled = false`). Same `import EzoicAdsSDK`; none of the CMP's code is linked. See [Using your own CMP](#using-your-own-cmp). |
| `EzoicCmpSDK` | The built-in CMP alone, for Ezoic publishers whose app doesn't use Ezoic ads. |

Each comes with `EzoicConsentCore`, a small module with the consent types
(`ConsentOutcome`, `ConsentDecisionType`, `EzoicErrorCode`) that
`import EzoicAdsSDK` and `import EzoicCmpSDK` re-export; you don't add it
yourself.

Xcode resolves three transitive packages alongside `EzoicAdsSDK`:

- `prebid-mobile-ios-sdk` (https://github.com/prebid/prebid-mobile-ios-sdk,
  pinned to the exact version the binary was built against; currently
  3.4.1) for header bidding. If your app also depends on Prebid directly,
  use this URL and the same version.
- `swift-package-manager-google-mobile-ads` (13.x) for GAM
- `swift-package-manager-amazon-aps`
  (https://github.com/amzn/swift-package-manager-amazon-aps, exactly
  5.6.6) for Amazon APS. If your app also adds Amazon's package, use the
  same version.

### Swift Package Manager (Package.swift)

```swift
dependencies: [
    .package(
        url: "https://github.com/ezoic/ezoic-swift-sdk-dist.git",
        exact: "1.23.1"
    )
],
targets: [
    .target(
        name: "MyApp",
        dependencies: [
            .product(name: "EzoicAdsSDK", package: "ezoic-swift-sdk-dist")
            // or, with your own CMP:
            // .product(name: "EzoicAdsSDKWithoutCMP", package: "ezoic-swift-sdk-dist")
        ]
    )
]
```

### Using your own CMP

If your app runs another CMP (Google UMP, OneTrust, Didomi, …), add the
`EzoicAdsSDKWithoutCMP` product instead of `EzoicAdsSDK` and set
`cmpEnabled = false`:

```swift
let configuration = EzoicConfiguration(domain: "example.com", cmpEnabled: false)
```

The SDK reads your CMP's `IABTCF_*` / `IABGPP_*` keys as before and
behaves exactly as with `cmpEnabled = false`; none of the built-in CMP's
code is in your app. `EzoicAds.isBuiltInCmpIncluded` is `false` in such an
app. Available from 1.24.0.

Don't combine `EzoicAdsSDKWithoutCMP` with the `EzoicCmpSDK` product: an app
that uses Ezoic ads and the built-in CMP adds `EzoicAdsSDK`, which includes it.

### CocoaPods (frozen)

CocoaPods trunk becomes read-only on December 2, 2026. Versions already
on trunk keep installing, but no new versions are published there after
the last one pushed before December 1, 2026. Use Swift Package Manager
to keep getting updates.

```ruby
pod 'EzoicAdsSDK', '~> 1.0'
```

Then `pod install`. The pod vends a CocoaPods build of the same sources
and brings in `PrebidMobile`, `Google-Mobile-Ads-SDK` and
`AmazonPublisherServicesSDK` transitively. In Swift, import the binary
module:

```swift
import EzoicAdsSDKBinary
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
`1.0.0-rc6`). Stable releases (`1.0.0`, `1.1.0`, …) follow
[semantic versioning](https://semver.org). Pre-release tags
(`1.0.0-rc1`, `1.0.0-rc2`, …) carry the same parity contract as the
Kotlin SDK release candidates on Maven Central.

## Support

Contact your Ezoic account representative for integration support.

## License

Proprietary — see https://www.ezoic.com/terms.
