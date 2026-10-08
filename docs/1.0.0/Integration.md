# Ströer iOS SDK Integration

This document describes how to integrate the Ströer iOS SDK and request banner, interstitial, and rewarded ads.

For a complete working implementation, see the [Example App](../ExampleApp).

## Requirements

- iOS 15.0 or later
- An `APPLICATION_NAME`
- A `PUBLISHER_CALL_STRING` for each ad placement

Please contact your Ströer account manager to receive the required configuration.

The `APPLICATION_NAME` identifies your application and should be configured once when the application starts.

The `PUBLISHER_CALL_STRING` identifies an ad placement and is passed when creating an ad.

---

## Installation

The Ströer iOS SDK can be integrated using Swift Package Manager or CocoaPods.

### Swift Package Manager

In Xcode:

1. Open **File → Add Package Dependencies**
2. Enter:

```text
https://github.com/stroeersdk/iOS
```

3. Select the required SDK version.
4. Add `StroeerSDK` to your application target.

Then import the SDK:

```swift
import StroeerSDK
```

### CocoaPods

Add the Ströer SDK to your `Podfile`:

```ruby
pod 'StroeerSDK',
    :podspec => 'https://stroeersdk.github.io/iOS/cocoapods/1.0.0/StroeerSDK.podspec'
```

Then run:

```bash
pod install
```

The public `StroeerSDK.podspec` contains the Core SDK and the optional Consent integration.

For Confiant integration, see [Confiant Integration](./Confiant_Integration.md).

---

## SDK Setup

Initialize the SDK once when your application starts.

```swift
import StroeerSDK

Stroeer.setup(appName: "APPLICATION_NAME")
```

Replace `APPLICATION_NAME` with the app name supplied by Ströer.

For example:

```swift
Stroeer.setup(appName: "my-app-name")
```

Ad requests can then be created using the publisher call strings configured for the application.

---

## Test Configuration

The following test configuration can be used before receiving your production configuration:

| Type | Value |
| --- | --- |
| Application name | `appDfpTest` |
| Banner | `banner` |
| Large banner | `banner?large` |
| Interstitial | `interstitial` |
| Rewarded | `rewarded` |

Example:

```swift
Stroeer.setup(appName: "appDfpTest")
```

---

# Banner Ads

Banner ads are displayed using `StroeerBannerView`.

Create the banner with its publisher call string, the presenting view controller, and a `StroeerBannerViewDelegate`.

The banner should be retained by the publisher and added to the view hierarchy.

```swift
import UIKit
import StroeerSDK

final class BannerViewController: UIViewController, StroeerBannerViewDelegate {

    private var bannerView: StroeerBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let banner = StroeerBannerView(
            adSlotId: "PUBLISHER_CALL_STRING",
            publisherViewController: self,
            publisherDelegate: self
        )

        bannerView = banner

        view.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            banner.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            )
        ])

        banner.load()
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

Replace `PUBLISHER_CALL_STRING` with the banner placement supplied by Ströer.

## Banner Size

The SDK manages the rendered banner size internally.

After an ad has loaded, its final size can be read using:

```swift
let size = bannerView.getBannerSize()

print("width: \(size.width)")
print("height: \(size.height)")
```

Applications with dynamic layouts can use this value to update the surrounding layout if required.

## Refreshing a Banner

A banner can be refreshed manually using:

```swift
bannerView.refresh()
```

If auto-refresh is enabled for the placement in the Ströer configuration, the SDK manages its refresh cycle automatically.

## Destroying a Banner

When a banner is permanently removed and should no longer request ads, it can be explicitly destroyed:

```swift
bannerView.destroy()
bannerView = nil
```

`destroy()` stops the banner lifecycle and any active refresh cycle.

---

# Interstitial Ads

Interstitial ads are loaded using `StroeerInterstitialView`.

Keep a strong reference to the interstitial while it is loading and being presented.

```swift
import UIKit
import StroeerSDK

final class InterstitialViewController: UIViewController, StroeerInterstitialDelegate {

    private var interstitial: StroeerInterstitialView?

    func loadInterstitial() {
        let interstitial = StroeerInterstitialView(
            adSlotId: "PUBLISHER_CALL_STRING",
            publisherDelegate: self
        )

        self.interstitial = interstitial
        interstitial.load()
    }

    func onAdLoaded(interstitial: StroeerInterstitialView) {
        print("Interstitial loaded")

        interstitial.show(viewController: self)
    }

    func onAdFailedToLoad(
        interstitial: StroeerInterstitialView?,
        error: Error
    ) {
        print("Interstitial failed to load: \(error.localizedDescription)")
    }
}
```

Replace `PUBLISHER_CALL_STRING` with the interstitial placement supplied by Ströer.

An interstitial should only be presented after it has successfully loaded.

You do not have to show it immediately from `onAdLoaded`. You can retain the loaded `StroeerInterstitialView` and present it later when appropriate:

```swift
interstitial?.show(viewController: self)
```

## Async Loading

Swift applications can also use the async loading API:

```swift
func loadInterstitial() async {
    let interstitial = StroeerInterstitialView(
        adSlotId: "PUBLISHER_CALL_STRING",
        publisherDelegate: self
    )

    self.interstitial = interstitial

    do {
        try await interstitial.loadAsync()

        interstitial.show(viewController: self)
    } catch {
        print("Interstitial failed to load: \(error.localizedDescription)")
    }
}
```

Use either `load()` with delegate-based load callbacks or `loadAsync()` for the load operation.

---

# Rewarded Ads

Rewarded ads are loaded using `StroeerRewardedView`.

The rewarded ad should be retained while it is loading and throughout its presentation lifecycle.

```swift
import UIKit
import StroeerSDK

final class RewardedViewController: UIViewController, StroeerRewardedDelegate {

    private var rewarded: StroeerRewardedView?

    func loadRewarded() {
        let rewarded = StroeerRewardedView(
            adSlotId: "PUBLISHER_CALL_STRING",
            publisherDelegate: self
        )

        self.rewarded = rewarded
        rewarded.load()
    }

    func onAdLoaded(rewarded: StroeerRewardedView) {
        print("Rewarded ad loaded")

        // The ad is now ready to be presented.
        // Enable your application's "Watch Ad" button here if required.
    }

    func onAdFailedToLoad(
        rewarded: StroeerRewardedView?,
        error: Error
    ) {
        print("Rewarded ad failed to load: \(error.localizedDescription)")
    }

    func onAdDismissedFullScreenContent(
        rewarded: StroeerRewardedView
    ) {
        print("Rewarded ad dismissed")
    }
}
```

Present the loaded rewarded ad when appropriate:

```swift
rewarded?.show(viewController: self)
```

The reward must only be granted when the `StroeerRewardedDelegate` receives the `onUserEarnedReward` callback.

Do not grant the reward simply because the ad loaded or was dismissed.

## Async Loading

Rewarded ads also support async loading:

```swift
func loadRewarded() async {
    let rewarded = StroeerRewardedView(
        adSlotId: "PUBLISHER_CALL_STRING",
        publisherDelegate: self
    )

    self.rewarded = rewarded

    do {
        try await rewarded.loadAsync()

        // The rewarded ad is now ready to show.
    } catch {
        print("Rewarded ad failed to load: \(error.localizedDescription)")
    }
}
```

After a successful load:

```swift
rewarded?.show(viewController: self)
```

---

# Content URL

The URL of the content associated with an ad request can be supplied before loading the ad.

For a banner:

```swift
banner.contentUrl = "https://www.example.com/article"
banner.load()
```

For an interstitial:

```swift
interstitial.contentUrl = "https://www.example.com/article"
interstitial.load()
```

For a rewarded ad:

```swift
rewarded.contentUrl = "https://www.example.com/article"
rewarded.load()
```

Set the content URL before starting the corresponding load operation.

---

# Custom Targeting

Custom key-value targeting can be supplied directly on an ad object before loading it.

For example:

```swift
banner.customTargeting = [
    "section": "sports",
    "loggedIn": "true"
]

banner.load()
```

The same property is available for interstitial and rewarded ads:

```swift
interstitial.customTargeting = [
    "section": "sports"
]

rewarded.customTargeting = [
    "section": "sports"
]
```

Targeting should be configured before calling `load()` or `loadAsync()`.

---

# Combining Content URL and Custom Targeting

Both values can be configured together:

```swift
let banner = StroeerBannerView(
    adSlotId: "PUBLISHER_CALL_STRING",
    publisherViewController: self,
    publisherDelegate: self
)

banner.contentUrl = "https://www.example.com/sports/article"

banner.customTargeting = [
    "section": "sports",
    "articleType": "news"
]

bannerView = banner
view.addSubview(banner)

banner.load()
```

---

# Ad Lifecycle Callbacks

The SDK exposes publisher delegates for receiving ad lifecycle events.

Depending on the ad type, callbacks are available for events such as:

- ad loaded
- ad failed to load
- impression recorded
- ad clicked
- full-screen content shown
- full-screen content dismissed
- full-screen presentation failure
- rewarded user event

Implement only the callbacks required by your application.

---

# Object Lifetime

Publishers should keep strong references to active ad objects.

For banners:

```swift
private var bannerView: StroeerBannerView?
```

For interstitials:

```swift
private var interstitial: StroeerInterstitialView?
```

For rewarded ads:

```swift
private var rewarded: StroeerRewardedView?
```

Do not create an ad only as a temporary local variable if it is expected to continue loading, refresh, present, or deliver lifecycle callbacks after that scope ends.

For banners that are permanently removed from the UI, call:

```swift
bannerView?.destroy()
bannerView = nil
```

Interstitial and rewarded objects should be retained through their presentation lifecycle and can be released when they are no longer needed.

---

# Complete Basic Setup

A minimal integration consists of initializing the SDK once:

```swift
import StroeerSDK

Stroeer.setup(appName: "APPLICATION_NAME")
```

and then creating an ad with the corresponding publisher call string:

```swift
let banner = StroeerBannerView(
    adSlotId: "PUBLISHER_CALL_STRING",
    publisherViewController: self,
    publisherDelegate: self
)

bannerView = banner
view.addSubview(banner)
banner.load()
```

The actual `APPLICATION_NAME` and `PUBLISHER_CALL_STRING` values are provided by Ströer.

---

# Additional Documentation

- [Example App](../ExampleApp)
- [CMP Integration](./CMP_Integration.md)
- [Confiant Integration](./Confiant_Integration.md)

For questions about your application configuration, publisher call strings, or available ad placements, please contact your Ströer account manager.
