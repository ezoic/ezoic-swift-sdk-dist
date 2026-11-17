//
// Ezoic consent core — public-facing wrapper
//
// Same pattern as Sources/EzoicAdsSDK/Exports.swift: the consumer-facing
// module is `EzoicConsentCore`, the XCFramework module is
// `EzoicConsentCoreBinary`, and this re-export makes `ConsentOutcome`,
// `ConsentDecisionType` and `EzoicErrorCode` visible. Apps don't add it
// directly: `import EzoicAdsSDK` and `import EzoicCmpSDK` re-export it.
//
// Don't add anything else to this file.

@_exported import EzoicConsentCoreBinary
