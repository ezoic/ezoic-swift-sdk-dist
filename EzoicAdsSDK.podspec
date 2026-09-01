Pod::Spec.new do |s|
  s.name             = 'EzoicAdsSDK'
  s.version          = '1.6.0'
  s.summary          = 'Ezoic Ads SDK for iOS (Prebid + Google Ad Manager).'
  s.description      = <<-DESC
    The official Ezoic Ads SDK for iOS. Closed-source binary distributed as an
    XCFramework. Mirrors the SwiftPM distribution at
    github.com/ezoic/ezoic-swift-sdk-dist. The vended framework module is
    `EzoicAdsSDKBinary`; import it from Swift as `import EzoicAdsSDKBinary`.
  DESC
  s.homepage         = 'https://github.com/ezoic/ezoic-swift-sdk-dist'
  s.license          = { :type => 'Proprietary', :text => 'Copyright (c) 2026 Ezoic Inc. All rights reserved. Governed by the Ezoic Terms of Service at https://www.ezoic.com/terms' }
  s.author           = { 'Ezoic Inc' => 'support@ezoic.com' }
  s.platform         = :ios, '14.0'
  s.swift_version    = '5.9'

  # The xcframework is downloaded from the matching GitHub Release. The zip's
  # top-level entry is `EzoicAdsSDKBinary.xcframework` (see build-xcframework.sh
  # in the source repo). Do NOT re-zip a published release: the SHA changes and
  # SwiftPM consumers break.
  s.source = {
    :http => "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/#{s.version}/EzoicAdsSDK-#{s.version}.xcframework.zip"
  }
  s.vendored_frameworks = 'EzoicAdsSDKBinary.xcframework'

  # The binary's .swiftinterface references these modules, so consumers need
  # them on the search path. CocoaPods pod names -> modules:
  #   PrebidMobile               -> PrebidMobile
  #   Google-Mobile-Ads-SDK      -> GoogleMobileAds
  #   AmazonPublisherServicesSDK -> DTBiOSSDK
  s.dependency 'PrebidMobile', '~> 3.1'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 12.0'
  # Amazon APS (TAM). Exact 5.3.3: the compiled binary's DTBiOSSDK
  # references are verified against the 5.3.3 headers.
  s.dependency 'AmazonPublisherServicesSDK', '5.3.3'
end
