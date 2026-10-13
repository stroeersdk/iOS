Pod::Spec.new do |spec|
  spec.name               = 'StroeerSDK'
  spec.version            = '1.0.0'
  spec.summary            = 'A lightweight SDK that helps publishers maximize ad revenue across mobile websites and apps.'
  spec.license            = {
    :type => 'Commercial',
    :file => 'stroeer-sdk-1.0.0/StroeerSDK/LICENSE'
  }
  spec.description        = 'We provide publishers with a platform that maximizes ad monetization, ensuring every impression is optimized for top-tier revenue performance.'
  spec.homepage           = 'https://yieldlove.com/'
  spec.documentation_url  = 'https://stroeerdigitalgroup.atlassian.net/wiki/x/FgGyc'
  spec.author             = {
    'Stroeer Labs' => 'stroeerlabs@adscale.co.nz'
  }
  spec.source             = {
    :http => 'https://github.com/stroeersdk/iOS/releases/download/1.0.0/stroeer-sdk-1.0.0.zip'
  }

  spec.requires_arc       = true
  spec.platforms          = { :ios => '15.0' }
  spec.static_framework   = true
  spec.swift_version      = '5.0'

  spec.default_subspecs = 'Core'

  spec.subspec 'Core' do |core|
    core.vendored_frameworks = [
      'stroeer-sdk-1.0.0/StroeerSDK/Frameworks/StroeerSDK.xcframework'
    ]

    core.resource_bundles = {
      'StroeerSDK' => [
        'stroeer-sdk-1.0.0/StroeerSDK/Resources/Core/dashboard.html',
        'stroeer-sdk-1.0.0/StroeerSDK/Resources/Core/debuginfo.html',
        'stroeer-sdk-1.0.0/StroeerSDK/Resources/Core/PrivacyInfo.xcprivacy'
      ]
    }

    core.dependency 'PrebidMobile', '3.4.1'
    core.dependency 'Google-Mobile-Ads-SDK', '13.7.0'
  end

  spec.subspec 'Consent' do |consent|
    consent.vendored_frameworks = [
      'stroeer-sdk-1.0.0/StroeerSDK/Frameworks/StroeerSDK_Consent.xcframework'
    ]

    consent.resource_bundles = {
      'StroeerSDKConsent' => [
        'stroeer-sdk-1.0.0/StroeerSDK/Resources/Consent/PrivacyInfo.xcprivacy'
      ]
    }

    consent.dependency 'StroeerSDK/Core'
    consent.dependency 'ConsentViewController', '~>7.12'
  end

  spec.subspec 'Confiant' do |confiant|
    confiant.vendored_frameworks = [
      'stroeer-sdk-1.0.0/StroeerSDK/Frameworks/StroeerSDK_Confiant.xcframework'
    ]

    confiant.dependency 'StroeerSDK/Core'
    confiant.dependency 'ConfiantSDK', '6.1.4'
  end
end
