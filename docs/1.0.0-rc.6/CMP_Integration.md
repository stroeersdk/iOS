# Ströer iOS SDK – CMP Integration

This guide explains how to integrate the Ströer Consent Management Platform (CMP) module into an iOS application.

The Ströer iOS CMP integration is based on Sourcepoint and is provided through the `StroeerSDK_Consent` module.

For the general SDK setup and ad integration, see [Integration.md](Integration.md).

---

## Requirements

- iOS 15.0 or newer
- Ströer iOS SDK
- A valid Ströer application configuration
- Sourcepoint must be configured for your application by Ströer

Before integrating CMP, make sure the main Ströer SDK is configured correctly.

---

## Installation

### Swift Package Manager

Add the Ströer iOS SDK package to your Xcode project:

```text
https://github.com/stroeersdk/iOS
```

Select the version you want to use and add the following product to your application target:

```text
StroeerSDK_Consent
```

The Consent product depends on the Ströer Core SDK.

### CocoaPods

The public Ströer CocoaPods specification contains both Core and Consent.

```ruby
pod 'StroeerSDK',
    :podspec => 'https://stroeersdk.github.io/iOS/cocoapods/StroeerSDK.podspec',
    :subspecs => ['Consent']
```

Then run:

```bash
pod install
```

---

## Import

Import the Ströer Consent module:

```swift
import StroeerSDK
import StroeerSDK_Consent
import ConsentViewController
```

`ConsentViewController` provides the Sourcepoint types exposed through the consent callbacks, such as `SPUserData` and `SPAction`.

---

## Initialize the Ströer SDK

Initialize the Ströer SDK before using the CMP.

```swift
Stroeer.setup(appName: "YOUR_APP_NAME")
```

Replace `YOUR_APP_NAME` with the application name provided by Ströer.

The Ströer SDK setup initializes the remote configuration used by the Consent module.

Consent collection itself is not started automatically by `Stroeer.setup`.

---

## Create the consent handler

Implement `StroeerConsentPublisherDelegate` to receive CMP lifecycle events.

```swift
final class ConsentHandler: StroeerConsentPublisherDelegate {

    func onSPUIReady() {
        // The consent message or Privacy Manager is ready to be shown.
    }

    func onSPUIFinished() {
        // The consent UI has been closed.
    }

    func onConsentReady(consents: SPUserData) {
        // Sourcepoint consent information is available.
    }

    func onError(error: StroeerConsentError) {
        print("Consent error: \(error)")
    }

    func onAction(action: SPAction) {
        // The user performed an action in the Sourcepoint UI.
    }

    func onSPFinished(consents: SPUserData) {
        // Sourcepoint has finished processing the consent flow.
    }
}
```

Keep the delegate alive for as long as the consent operation is active.

For example:

```swift
private let consentDelegate = ConsentHandler()
```

---

## Create the consent instance

Create and retain a `StroeerConsent` instance:

```swift
private let consent = StroeerConsent()
```

The same instance can be used to collect consent, open the Privacy Manager and clear consent data.

---

## Collect consent

Present the consent flow using a view controller that is currently part of your application's active UI.

```swift
consent.collect(
    viewController: self,
    delegate: consentDelegate
)
```

A complete UIKit example:

```swift
import UIKit
import StroeerSDK
import StroeerSDK_Consent
import ConsentViewController

final class ViewController: UIViewController {

    private let consent = StroeerConsent()
    private let consentDelegate = ConsentHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        Stroeer.setup(appName: "YOUR_APP_NAME")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        consent.collect(
            viewController: self,
            delegate: consentDelegate
        )
    }
}
```

Whether a consent message is actually displayed depends on the Sourcepoint configuration and the user's existing consent state.

For example, if the user has already provided valid consent, Sourcepoint may complete the flow without displaying the consent message again.

---

## SwiftUI

When integrating the CMP in a SwiftUI application, provide an active `UIViewController` to the SDK.

Example:

```swift
if let windowScene = UIApplication.shared.connectedScenes
    .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
   let rootViewController = windowScene.windows
    .first(where: { $0.isKeyWindow })?
    .rootViewController {

    consent.collect(
        viewController: rootViewController,
        delegate: consentDelegate
    )
}
```

Your application may use a different mechanism to obtain the currently presented view controller.

---

## Privacy Manager

The Privacy Manager allows the user to review or change previously stored privacy choices.

```swift
consent.showPrivacyManager(
    viewController: self,
    delegate: consentDelegate
)
```

For example, this can be connected to a Privacy Settings button:

```swift
@IBAction func privacySettingsTapped(_ sender: UIButton) {
    consent.showPrivacyManager(
        viewController: self,
        delegate: consentDelegate
    )
}
```

The Privacy Manager configuration, including its identifier and available choices, is supplied through the Ströer configuration.

---

## Clear consent data

For development, testing, or another application flow where consent must be cleared:

```swift
consent.clearConsentData(
    delegate: consentDelegate
)
```

After clearing consent data, the next consent collection may show the consent message again depending on the Sourcepoint configuration.

Do not automatically clear consent during normal application startup.

---

## Consent lifecycle

A typical integration looks like this:

```text
Application starts
        │
        ▼
Stroeer.setup(appName:)
        │
        ▼
Create / retain StroeerConsent
        │
        ▼
consent.collect(...)
        │
        ├── onSPUIReady()
        │
        ├── user interacts with CMP
        │
        ├── onAction(...)
        │
        ├── onConsentReady(...)
        │
        ├── onSPUIFinished()
        │
        └── onSPFinished(...)
```

The exact callbacks received depend on the Sourcepoint flow and whether a consent message needs to be displayed.

---

## When to load ads

The CMP and ad APIs are separate parts of the SDK.

`Stroeer.setup(appName:)` does not automatically collect consent.

Your application should start the consent flow according to the consent requirements agreed with Ströer before beginning normal ad serving.

A simple application flow can therefore be:

```swift
Stroeer.setup(appName: "YOUR_APP_NAME")

consent.collect(
    viewController: self,
    delegate: consentDelegate
)
```

Then continue your application/ad flow when the appropriate consent callback is received.

---

## Important integration notes

### Retain the consent object

Keep the `StroeerConsent` instance alive while using the CMP.

Recommended:

```swift
private let consent = StroeerConsent()
```

Avoid creating it only as a temporary local variable.

### Retain the delegate

Keep your `StroeerConsentPublisherDelegate` implementation alive while the flow is active.

```swift
private let consentDelegate = ConsentHandler()
```

### Use an active view controller

`collect` and `showPrivacyManager` require a view controller from which the Sourcepoint UI can be presented.

### CMP configuration is remote

Sourcepoint account information, property configuration and Privacy Manager configuration are normally supplied through the Ströer SDK configuration.

Publishers should not hard-code Sourcepoint account configuration unless specifically instructed by Ströer.

### Do not clear consent on every launch

`clearConsentData` is primarily useful for testing or explicit user/application flows.

Clearing data on every startup would prevent the CMP from preserving the user's existing consent state.

---

## Example

A minimal complete implementation:

```swift
import UIKit
import StroeerSDK
import StroeerSDK_Consent
import ConsentViewController

final class ConsentHandler: StroeerConsentPublisherDelegate {

    func onSPUIReady() {
        print("CMP UI ready")
    }

    func onSPUIFinished() {
        print("CMP UI finished")
    }

    func onConsentReady(consents: SPUserData) {
        print("Consent ready")
    }

    func onError(error: StroeerConsentError) {
        print("CMP error: \(error)")
    }

    func onAction(action: SPAction) {
        print("CMP action: \(action)")
    }

    func onSPFinished(consents: SPUserData) {
        print("CMP finished")
    }
}

final class ViewController: UIViewController {

    private let consent = StroeerConsent()
    private let consentDelegate = ConsentHandler()

    override func viewDidLoad() {
        super.viewDidLoad()

        Stroeer.setup(appName: "YOUR_APP_NAME")
    }

    func collectConsent() {
        consent.collect(
            viewController: self,
            delegate: consentDelegate
        )
    }

    func showPrivacyManager() {
        consent.showPrivacyManager(
            viewController: self,
            delegate: consentDelegate
        )
    }

    func clearConsent() {
        consent.clearConsentData(
            delegate: consentDelegate
        )
    }
}
```

---

## Example application

The Ströer iOS example application contains a working CMP integration:

https://github.com/stroeersdk/iOS/tree/main/ExampleApp

It demonstrates:

- collecting consent
- opening the Privacy Manager
- clearing consent data
- implementing `StroeerConsentPublisherDelegate`

---

## Related documentation

- [iOS SDK Integration](Integration.md)
- [Confiant Integration](Confiant_Integration.md)
- [Ströer iOS SDK repository](https://github.com/stroeersdk/iOS)
