//
// Ezoic CMP SDK — public-facing wrapper
//
// Same pattern as Sources/EzoicAdsSDK/Exports.swift: the consumer-facing
// module is `EzoicCmpSDK`, the XCFramework module is `EzoicCmpSDKBinary`,
// and this re-export makes `EzoicCmp`, `ConsentOutcome`, `CmpError`, …
// visible to anyone who writes `import EzoicCmpSDK`.
//
// Don't add anything else to this file.

@_exported import EzoicCmpSDKBinary
