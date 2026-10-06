//
//  BannerView.swift
//  SimpleAdTest
//
//  Created by Hyungon Kim on 22/07/2024.
//

import Foundation
import SwiftUI

struct BannerView : View
{
    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            
            Spacer()
            
            BannerViewRepresentable(
                slotId: "b2",
                //contentUrl: "localContentUrl.com",
                customTargeting : ["localTarget": "localValue"]
            )
            
            Spacer()
        }
        .background(
            Color("Background")
        )
    }
}
