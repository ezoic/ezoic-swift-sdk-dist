Pod::Spec.new do |s|
  s.name             = 'EzoicAdsSDK'
  s.version          = '1.14.0'
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
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.9'

  # The xcframework is downloaded from the matching GitHub Release. The zip's
  # top-level entry is `EzoicAdsSDKBinary.xcframework` (see build-xcframework.sh
  # in the source repo).
  #
  # CocoaPods gets its own `-cocoapods` build of the same sources: the
  # PrebidMobile pod is built with BUILD_LIBRARY_FOR_DISTRIBUTION=YES while
  # SwiftPM builds Prebid without it, and since the static framework links the
  # host's Prebid it must be compiled against the matching ABI flavour. The
  # SwiftPM zip (no suffix) will not link under CocoaPods and vice versa.
  s.source = {
    :http => "https://github.com/ezoic/ezoic-swift-sdk-dist/releases/download/#{s.version}/EzoicAdsSDK-#{s.version}-cocoapods.xcframework.zip"
  }
  s.vendored_frameworks = 'EzoicAdsSDKBinary.xcframework'

  # The binary's .swiftinterface references these modules, so consumers need
  # them on the search path. CocoaPods pod names -> modules:
  #   PrebidMobile               -> PrebidMobile
  #   Google-Mobile-Ads-SDK      -> GoogleMobileAds
  #   AmazonPublisherServicesSDK -> DTBiOSSDK
  # Exact: the static XCFramework links the consumer's PrebidMobile (it no
  # longer embeds a private copy), and PrebidMobile's Swift ABI is not
  # library-evolution stable — must match the version the binary was built
  # against (source repo Package.resolved). Keep in step with Package.swift.
  s.dependency 'PrebidMobile', '3.2.1'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 12.0'
  # Amazon APS (TAM). Exact 5.3.3: the compiled binary's DTBiOSSDK
  # references are verified against the 5.3.3 headers.
  s.dependency 'AmazonPublisherServicesSDK', '5.3.3'
end
