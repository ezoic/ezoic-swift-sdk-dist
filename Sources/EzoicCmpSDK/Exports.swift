//
// Ezoic CMP SDK — public-facing wrapper
//
// Same pattern as Sources/EzoicAdsSDK/Exports.swift: the consumer-facing
// module is `EzoicCmpSDK`, the XCFramework module is `EzoicCmpSDKBinary`,
// and this re-export makes `EzoicCmp`, `CmpError`, … (and, through the
// binary's own re-export of the consent core, `ConsentOutcome`) visible to
// anyone who writes `import EzoicCmpSDK`.
//
// Don't add anything else to this file.

@_exported import EzoicCmpSDKBinary
