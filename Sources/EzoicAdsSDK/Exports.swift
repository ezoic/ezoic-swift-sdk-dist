//
// Ezoic Ads SDK — public-facing wrapper
//
// This file is the *only* Swift source in the dist repo. It exists so
// the consumer-facing module is called `EzoicAdsSDK` even though the
// underlying XCFramework module name is `EzoicAdsSDKBinary`. The
// `@_exported import` makes every symbol from the binary (the
// `EzoicAds` singleton, `EzoicConfiguration`, `EzoicBannerView`, …)
// visible to anyone who writes `import EzoicAdsSDK`.
//
// Don't add anything else to this file. Real SDK code lives in the
// private source repo; the binary it produces is the source of truth.

@_exported import EzoicAdsSDKBinary
