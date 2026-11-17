//
// Ezoic Ads SDK — links the built-in CMP
//
// Part of the `EzoicAdsSDK` product, not of `EzoicAdsSDKWithoutCMP`. The ads
// SDK finds the built-in CMP at runtime by its Objective-C class name and
// never references it, so on its own the static linker would leave every CMP
// object file out of the app. This reference to the provider class makes the
// linker load it (and everything it uses); the Objective-C class list then
// keeps it alive under dead stripping.
//
// Don't add anything else to this file.

@_spi(EzoicInternal) import EzoicCmpSDKBinary

/// Not API: referenced only to link the built-in CMP.
public let _ezoicBuiltInCmpProviderClass: AnyClass = BuiltInCmpProvider.self
