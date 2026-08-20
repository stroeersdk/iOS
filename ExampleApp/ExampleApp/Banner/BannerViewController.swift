//
//  BannerViewController.swift
//  SimpleAdTest
//
//  Created by Hyungon Kim on 22/07/2024.
//

import SwiftUI
import StroeerSDK
import GoogleMobileAds

class BannerViewController: UIViewController, StroeerBannerViewDelegate {

    var slotId: String = ""
    var onAdSize: ((CGSize) -> Void)?

    private var bannerView: StroeerBannerView?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear

        print("[BANNER_LOAD] slot=\(slotId)")

        let bannerView = Stroeer.instance.bannerAd(
            adSlotId: slotId,
            viewController: self,
            delegate: self
        )
        self.bannerView = bannerView
        view.addSubview(bannerView)
    }

    func getGAMRequest() -> AdManagerRequest {
        let request = AdManagerRequest()
        request.contentURL = "https://www.stroeer.de/"
        return request
    }

    func bannerViewDidReceiveAd(_ bannerView: StroeerBannerView) {
        print("banner size = \(bannerView.getBannerSize())")
        onAdSize?(bannerView.getBannerSize())
    }

    func bannerView(_ bannerView: StroeerBannerView, didFailToReceiveAdWithError error: Error) {
        print("[BANNER_ERROR] slot=\(bannerView.bannerConfiguration.adSlotId) error=\(error.localizedDescription)")
    }

    func bannerViewWillPresentScreen(_ bannerView: StroeerBannerView) {
        print("PRESENTED!!! for \(bannerView.bannerConfiguration.adSlotId)")
    }

    func bannerViewWillDismissScreen(_ bannerView: StroeerBannerView) {
        print("DISMISSED!!! for \(bannerView.bannerConfiguration.adSlotId)")
    }

    func bannerViewDidDismissScreen(_ bannerView: StroeerBannerView) {
        print("DISMISSED!!! for \(bannerView.bannerConfiguration.adSlotId)")
    }

    func bannerViewDidRecordClick(_ bannerView: StroeerBannerView) {
        print("CLICKED!!! for \(bannerView.bannerConfiguration.adSlotId)")
    }

    func bannerViewDidRecordImpression(_ bannerView: StroeerBannerView) {
        print("IMPRESSION!!! for \(bannerView.bannerConfiguration.adSlotId)")
    }
}
