# Ströer SDK for iOS

The Ströer SDK helps publishers integrate banner, interstitial, and rewarded ads into iOS applications. Optional modules are available for consent management (CMP) and ad-quality protection with Confiant.

## Documentation

- [iOS integration guide](https://stroeerdigitalgroup.atlassian.net/wiki/spaces/SDGPUBLIC/pages/1890713878/iOS+integration+documentation)
- [CMP integration guide](https://stroeerdigitalgroup.atlassian.net/wiki/spaces/SDGPUBLIC/pages/2408022033/iOS+CMP)
- [Confiant integration guide](https://stroeerdigitalgroup.atlassian.net/wiki/spaces/SDGPUBLIC/pages/4878991369/Confiant+Plugin+Documentation+for+iOS)

For interstitial, rewarded, targeting, consent, privacy, debugging, and lifecycle examples, see the complete integration guide.

## Requirements

- iOS 15.0 or newer
- Swift Package Manager or Cocoapods

Refer to the integration guide for currently supported dependency versions and third-party SDK compatibility.

## Installation

The SDK can be integrated using Swift Package Manager or Cocoapods.

---

## Swift Package Manager

### 1. Add the package

In Xcode:

**File → Add Package Dependencies...**

Add:

```text
https://github.com/stroeersdk/iOS
```

Select the SDK version you want to integrate.

### 2. Select the SDK modules

The package provides the following products:

```text
StroeerSDK
StroeerSDK_Consent
StroeerSDK_Confiant
```

`StroeerSDK` contains the core ad-serving functionality and is required.

Add the optional products only when those features are needed:

- `StroeerSDK_Consent` for consent management
- `StroeerSDK_Confiant` for Confiant ad-quality protection

### 3. Add `-ObjC` when using plugins

When integrating plugin modules such as Confiant through Swift Package Manager, add:

```text
-ObjC
```

to your application target under:

**Build Settings → Other Linker Flags**

---

## Cocoapods

The SDK is also available through Cocoapods.

### Core SDK and Consent

Add the public SDK podspec to your `Podfile`:

```ruby
pod 'StroeerSDK', '1.0.0'
```

This distribution contains the core SDK and consent functionality.

### Confiant

If your integration also requires Confiant, use:

```ruby
pod 'StroeerSDK',
  :podspec => 'https://raw.githubusercontent.com/stroeersdk/iOS/main/Cocoapods/StroeerSDK-Confiant.podspec',
  :subspecs => [
          'Confiant'
        ]
```

The Confiant distribution includes the SDK components required for the Confiant integration.

Then install the dependencies:

```bash
pod install --repo-update
```

## Basic setup

Configure the application name once during application startup:

```swift
import StroeerSDK

Stroeer.setup(appName: "APPLICATION_NAME")
```

Use the application name provided for your Ströer integration.

## Banner example

Import the core SDK and conform to `StroeerBannerViewDelegate`:

```swift
import UIKit
import StroeerSDK

final class BannerViewController: UIViewController, StroeerBannerViewDelegate {

    private var bannerView: StroeerBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        let bannerView = Stroeer.instance.bannerAd(
            adSlotId: "PUBLISHER_CALL_STRING",
            viewController: self,
            delegate: self
        )

        self.bannerView = bannerView

        bannerView.contentUrl = "https://www.stroeer.de/"
        bannerView.customTargeting = [
            "localTarget": "localValue"
        ]

        view.addSubview(bannerView)
    }

    func bannerViewDidReceiveAd(_ bannerView: StroeerBannerView) {
        print("Banner received with size: \(bannerView.getBannerSize())")
    }

    func bannerView(_ bannerView: StroeerBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner failed to load: \(error.localizedDescription)")
    }
}
```

The publisher is responsible for placing the banner in the application's layout. The SDK manages the final rendered banner size internally after the ad is loaded.

Use `getBannerSize()` when the application needs to read the rendered banner size.

## Optional modules

### Consent

When the consent module is included, import:

```swift
import StroeerSDK_Consent
```

See the integration guide for CMP configuration and consent handling.

### Confiant

When the Confiant module is included, import:

```swift
import StroeerSDK_Confiant
```

When using Confiant through Swift Package Manager, make sure `-ObjC` is present in the application's **Other Linker Flags**.

## Support

For onboarding details, production configuration, publisher call strings, or integration support, contact your Ströer account manager.
