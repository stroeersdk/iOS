# Ströer iOS SDK – Confiant Integration

This guide explains how to enable Confiant ad-quality protection with the Ströer iOS SDK.

Confiant is an optional integration. If your application requires Confiant, contact the Ströer team to obtain the required configuration and access.

For the general SDK setup and ad integration, see [Integration.md](Integration.md).

---

## Overview

The Ströer Confiant integration connects Confiant ad monitoring with ads served through the Ströer SDK.

The current integration is provided through the:

```text
StroeerSDK_Confiant
```

module.

Confiant must be initialized separately from the main Ströer SDK.

A typical setup is:

```text
Stroeer.setup(appName:)
        │
        ▼
Initialize ConfiantLoader
        │
        ▼
Load ads through the normal Ströer SDK APIs
```

Once initialized, the SDK connects supported banner ads to the Confiant integration automatically.

You do not need to manually pass individual banner views to Confiant.

---

## Requirements

- iOS 15.0 or newer
- Ströer iOS SDK
- `StroeerSDK_Confiant`
- A valid Confiant Property ID
- Confiant must be enabled for your application

Contact the Ströer team if you require Confiant integration.

### Confiant linker flag

When using `StroeerSDK_Confiant`, add:

```text
-ObjC
```

to the application target under:

**Build Settings → Other Linker Flags**

`-ObjC` is required for the Confiant integration to be loaded correctly.


---

## Installation

### Swift Package Manager

Add the Ströer iOS SDK package:

```text
https://github.com/stroeersdk/iOS
```

Select the required SDK version and add:

```text
StroeerSDK_Confiant
```

to your application target.

The Confiant product depends on the Ströer Core SDK.

---

## CocoaPods

Confiant is distributed using the Confiant-enabled Ströer podspec.

Because the Confiant SDK is not available through the normal public CocoaPods trunk, the Confiant CocoaPods source must also be available to your project.

Example:

```ruby
source 'https://cdn.cocoapods.org/'
source 'https://cdn.confiant-integrations.net/backend-integrations/in-app/releases/ios/podspecs.git'

pod 'StroeerSDK',
    :podspec => 'https://stroeersdk.github.io/iOS/cocoapods/StroeerSDK-Confiant.podspec',
    :subspecs => ['Confiant']
```

Then run:

```bash
pod install
```

The Ströer Confiant podspec declares the required Confiant SDK dependency.

Do not mix the normal public Ströer podspec and the Confiant-enabled podspec for the same target.

---

## Import

Import the Ströer Core and Confiant modules:

```swift
import StroeerSDK
import StroeerSDK_Confiant
```

---

## Initialize the Ströer SDK

Initialize the normal Ströer SDK first:

```swift
Stroeer.setup(appName: "YOUR_APP_NAME")
```

Replace `YOUR_APP_NAME` with the application name provided by Ströer.

---

## Obtain a Confiant Property ID

Confiant requires a Property ID.

The Property ID is specific to your publisher/application configuration.

Contact the Ströer team to obtain the correct value.

Do not use the Property ID from the Ströer example application in production.

---

## Initialize Confiant

Initialize Confiant using `ConfiantLoader`.

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
    enableReload: true
) { success in
    if success {
        print("Confiant initialized")
    } else {
        print("Confiant initialization failed")
    }
}
```

Replace:

```text
YOUR_CONFIANT_PROPERTY_ID
```

with the Property ID provided for your application.

---

## `enableReload`

The `enableReload` parameter controls what happens when Confiant blocks an advertisement.

```swift
enableReload: true
```

allows the integration to attempt to reload the affected advertisement.

```swift
enableReload: false
```

leaves the blocked advertisement without automatically requesting a replacement.

Unless you have been instructed otherwise by Ströer, use the setting agreed for your publisher integration.

Example:

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
    enableReload: true
) { success in
    print("Confiant initialized: \(success)")
}
```

---

## Complete setup example

```swift
import UIKit
import StroeerSDK
import StroeerSDK_Confiant

final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        Stroeer.setup(appName: "YOUR_APP_NAME")

        ConfiantLoader.shared.initialize(
            confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
            enableReload: true
        ) { success in
            if success {
                print("Confiant initialized successfully")
            } else {
                print("Confiant initialization failed")
            }
        }

        return true
    }
}
```

After initialization, continue using the normal Ströer ad APIs.

For example:

```swift
let banner = StroeerBannerView(
    adSlotId: "YOUR_AD_SLOT_ID",
    publisherViewController: self,
    publisherDelegate: self
)

banner.load()
```

No additional Confiant call is required for each banner.

---

## Test mode

Confiant provides a test mode for verifying the integration.

Enable it before initializing Confiant:

```swift
ConfiantLoader.shared.enableTestMode()

ConfiantLoader.shared.initialize(
    confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
    enableReload: true
) { success in
    print("Confiant test initialization: \(success)")
}
```

> **Important:** Test mode must never be enabled in production.

Confiant test mode intentionally causes advertisements to be treated as blocked so that the integration can be verified. :chatgpt-content-reference{index="2"}

Remove:

```swift
ConfiantLoader.shared.enableTestMode()
```

before creating a production build.

---

## Recommended initialization order

Initialize the SDK during application startup:

```swift
Stroeer.setup(appName: "YOUR_APP_NAME")

ConfiantLoader.shared.initialize(
    confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
    enableReload: true
) { success in
    // Optional initialization handling.
}
```

Then create and load ads normally.

Conceptually:

```text
Application launch
      │
      ▼
Stroeer.setup(appName:)
      │
      ▼
ConfiantLoader.initialize(...)
      │
      ▼
Create StroeerBannerView
      │
      ▼
banner.load()
      │
      ▼
Ströer SDK connects the banner to Confiant monitoring
```

---

## Banner integration

No Confiant-specific code needs to be added to each banner.

Create banners through the normal Ströer SDK API:

```swift
let banner = StroeerBannerView(
    adSlotId: "YOUR_AD_SLOT_ID",
    publisherViewController: self,
    publisherDelegate: self
)

banner.load()
```

The Ströer SDK handles the connection between supported banner rendering and the Confiant integration internally.

Do not initialize or attach Confiant directly to the internal Google Mobile Ads or Prebid views managed by the Ströer SDK.

---

## Initialization result

The completion closure indicates whether Confiant initialization succeeded.

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "YOUR_CONFIANT_PROPERTY_ID",
    enableReload: true
) { success in

    if success {
        // Confiant is ready.
    } else {
        // Confiant could not be initialized.
    }
}
```

How your application reacts to initialization failure depends on your publisher requirements.

Ad integration itself should continue to use the normal Ströer SDK APIs.

---

## Important integration notes

### Contact Ströer before enabling Confiant

Confiant requires publisher-specific configuration.

Do not copy a Property ID from another application.

### Initialize once

Initialize `ConfiantLoader` as part of your application-level SDK setup rather than once for every advertisement.

### Do not enable test mode in production

This is particularly important:

```swift
ConfiantLoader.shared.enableTestMode()
```

is for integration testing only.

### Do not access internal ad views

Publishers should continue working with:

```text
StroeerBannerView
```

rather than accessing or monitoring the SDK's internal GAM, Prebid or WebView objects.

### Use the Confiant-enabled dependency

Adding only the normal Core SDK does not provide the Confiant implementation.

Your application must include:

```text
StroeerSDK_Confiant
```

or the Confiant CocoaPods subspec.

---

## Troubleshooting

### Confiant does not initialize

Check:

- the application contains `StroeerSDK_Confiant`
- the correct Confiant Property ID is being used
- the required Confiant dependency is available
- the Ströer SDK has been initialized
- the Property ID belongs to the current application

### CocoaPods cannot resolve ConfiantSDK

Make sure the Confiant CocoaPods source is included:

```ruby
source 'https://cdn.confiant-integrations.net/backend-integrations/in-app/releases/ios/podspecs.git'
```

and that you are using the Confiant-enabled Ströer podspec.

### Every ad is being blocked

Check that test mode has not accidentally been enabled:

```swift
ConfiantLoader.shared.enableTestMode()
```

Test mode must not be enabled in production.

### Confiant works in development but not in production

Verify that:

- the production Property ID is correct
- test mode is disabled
- the Confiant-enabled SDK product is included in the production target
- the Confiant dependency is present in the production build

---

## Example application

The Ströer iOS example application contains a configurable Confiant integration:

https://github.com/stroeersdk/iOS/tree/main/ExampleApp

The example demonstrates initialization using:

```swift
ConfiantLoader.shared.initialize(
    confiantPropertyId: "...",
    enableReload: true
) { _ in }
```

and also provides a Confiant test-mode option for development.

---

## Related documentation

- [iOS SDK Integration](Integration.md)
- [CMP Integration](CMP_Integration.md)
- [Ströer iOS SDK repository](https://github.com/stroeersdk/iOS)

For publisher-specific Confiant configuration or Property IDs, contact the Ströer team.
