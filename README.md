# Ströer SDK for iOS

The Ströer SDK helps publishers integrate banner, interstitial, and rewarded ads into iOS applications.

Optional modules are available for consent management (CMP) and ad-quality protection with Confiant.

## Documentation

- [iOS integration guide](docs/1.0.0-rc.5/Integration.md)
- [CMP integration guide](docs/1.0.0-rc.5/CMP_Integration.md)
- [Confiant integration guide](docs/1.0.0-rc.5/Confiant_Integration.md)
- [Example application](ExampleApp)

## Requirements

- iOS 15.0 or newer
- Swift Package Manager or Cocoapods

Refer to the integration guides for currently supported dependency versions, targeting options, consent configuration, and third-party SDK compatibility.

## Installation

The SDK can be integrated using Swift Package Manager or Cocoapods.

### Swift Package Manager

#### 1. Add the package

In Xcode:

**File → Add Package Dependencies...**

Add:

```text
https://github.com/stroeersdk/iOS
```

Select the SDK version you want to integrate.

#### 2. Add the SDK modules

The package provides the following products:

| Product | Required | Purpose |
| --- | --- | --- |
| `StroeerSDK` | Yes | Banner, interstitial, and rewarded ads |
| `StroeerSDK_Consent` | No | Sourcepoint consent management wrapper |
| `StroeerSDK_Confiant` | No | Confiant ad-quality monitoring |

Add `StroeerSDK` to your application target.

Add the optional products only when your application requires those features.

### Confiant linker flag

When using `StroeerSDK_Confiant`, add:

```text
-ObjC
```

to the application target under:

**Build Settings → Other Linker Flags**

`-ObjC` is required for the Confiant integration to be loaded correctly.

## CocoaPods

### Core SDK

Add the Core SDK to your `Podfile`:

```ruby
pod 'StroeerSDK', '<SDK_VERSION>'
```

The default `StroeerSDK` subspec is `Core`.

### Consent

If your application uses the Ströer CMP integration, add:

```ruby
pod 'StroeerSDK/Consent', '<SDK_VERSION>'
```

The Consent subspec includes the Core SDK and the required Sourcepoint dependency.

### Confiant

If your application uses Confiant, use the Confiant podspec:

```ruby
pod 'StroeerSDK',
  :podspec => 'https://raw.githubusercontent.com/stroeersdk/iOS/main/cocoapods/StroeerSDK-Confiant.podspec',
  :subspecs => [
    'Confiant'
  ]
```

When using Confiant, also add:

```text
-ObjC
```

to the application target under:

**Build Settings → Other Linker Flags**

Then install the dependencies:

```bash
pod install --repo-update
```

Replace `<SDK_VERSION>` with the SDK version you want to integrate.

## Basic setup

Set the application name once during application startup:

```swift
import StroeerSDK

Stroeer.setup(appName: "APPLICATION_NAME")
```

Use the application name provided for your Ströer integration.

## Banner example

Create the banner, start loading, and add it to your application's layout:

```swift
import UIKit
import StroeerSDK

final class BannerViewController: UIViewController, StroeerBannerViewDelegate {

    private var bannerView: StroeerBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let bannerView = StroeerBannerView(
            adSlotId: "AD_SLOT_ID",
            publisherViewController: self,
            publisherDelegate: self
        )

        bannerView.contentUrl = "https://www.stroeer.de/"

        bannerView.customTargeting = [
            "localTarget": "localValue"
        ]

        self.bannerView = bannerView

        view.addSubview(bannerView)

        bannerView.load()
    }

    func bannerViewDidReceiveAd(_ bannerView: StroeerBannerView) {
        print("Banner loaded with size: \(bannerView.getBannerSize())")
    }

    func bannerView(
        _ bannerView: StroeerBannerView,
        didFailToReceiveAdWithError error: Error
    ) {
        print("Banner failed to load: \(error.localizedDescription)")
    }
}
```

The publisher is responsible for placing the banner in the application's layout.

Use `getBannerSize()` when the application needs the final rendered banner size.

When the banner is no longer needed, it can be explicitly released with:

```swift
bannerView.destroy()
```

`destroy()` stops the banner controller and its refresh cycle. It is also called automatically when the banner is deallocated.

## Interstitial example

Create and retain an interstitial instance:

```swift
import UIKit
import StroeerSDK

final class InterstitialViewController: UIViewController, StroeerInterstitialDelegate {

    private lazy var interstitial = StroeerInterstitialView(
        adSlotId: "AD_SLOT_ID",
        publisherDelegate: self
    )

    func loadInterstitial() {
        interstitial.load()
    }

    func onAdLoaded(interstitial: StroeerInterstitialView) {
        interstitial.show(viewController: self)
    }

    func onAdFailedToLoad(
        interstitial: StroeerInterstitialView?,
        error: Error
    ) {
        print("Interstitial failed to load: \(error.localizedDescription)")
    }

    func onAdDismissedFullScreenContent(
        interstitial: StroeerInterstitialView
    ) {
        // The interstitial was dismissed.
    }
}
```

Interstitial loading is also available using Swift concurrency:

```swift
do {
    try await interstitial.loadAsync()
    interstitial.show(viewController: self)
} catch {
    print("Interstitial failed to load: \(error.localizedDescription)")
}
```

When using `loadAsync()`, load success is reported by the method returning normally and load failure is reported by a thrown error.

## Rewarded example

Create and retain a rewarded ad instance:

```swift
import UIKit
import StroeerSDK

final class RewardedViewController: UIViewController, StroeerRewardedDelegate {

    private lazy var rewarded = StroeerRewardedView(
        adSlotId: "AD_SLOT_ID",
        publisherDelegate: self
    )

    func loadRewarded() {
        rewarded.load()
    }

    func onAdLoaded(rewarded: StroeerRewardedView) {
        rewarded.show(viewController: self)
    }

    func onAdFailedToLoad(
        rewarded: StroeerRewardedView?,
        error: Error
    ) {
        print("Rewarded ad failed to load: \(error.localizedDescription)")
    }

    func onUserEarnedReward(
        rewarded: StroeerRewardedView,
        amount: NSDecimalNumber,
        type: String
    ) {
        // Grant the reward to the user.
        print("Reward earned: \(amount) \(type)")
    }
}
```

Rewarded loading is also available using Swift concurrency:

```swift
do {
    try await rewarded.loadAsync()
    rewarded.show(viewController: self)
} catch {
    print("Rewarded ad failed to load: \(error.localizedDescription)")
}
```

When using `loadAsync()`, load success is reported by the method returning normally and load failure is reported by a thrown error.

Reward events continue to be delivered through `StroeerRewardedDelegate`.

## Consent

When using the optional Consent module, import:

```swift
import StroeerSDK
import StroeerSDK_Consent
```

Create and retain a `StroeerConsent` instance:

```swift
private let consent = StroeerConsent()
```

The Consent module provides the Ströer wrapper around Sourcepoint CMP functionality.

For consent collection, Privacy Manager, consent callbacks, clearing consent data, and custom consent handling, see the [CMP integration guide](docs/CMP_Integration.md).

## Confiant

When using the optional Confiant module, import:

```swift
import StroeerSDK
import StroeerSDK_Confiant
```

Initialize Confiant once with the property ID provided for your application:

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "CONFIANT_PROPERTY_ID"
)
```

If reload support is enabled for your integration:

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "CONFIANT_PROPERTY_ID",
    enableReload: true
)
```

The current iOS Confiant integration is wired into the Ströer banner lifecycle.

Publishers do not need to manually mark individual banner views.

When using Confiant, make sure the application target contains:

```text
-ObjC
```

under:

**Build Settings → Other Linker Flags**

For test mode, initialization details, and troubleshooting, see the [Confiant integration guide](docs/Confiant_Integration.md).

## Additional integration

For targeting, content URLs, global targeting, CMP configuration, Confiant, debugging, inspection mode, ad lifecycle callbacks, and additional examples, see the [complete iOS integration guide](docs/Integration.md).

## Support

For onboarding details, production configuration, publisher ad-slot IDs, Confiant property IDs, CMP configuration, or integration support, contact your Ströer account manager.

