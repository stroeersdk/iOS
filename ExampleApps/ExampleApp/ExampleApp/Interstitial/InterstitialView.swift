//
//  InterstitialView.swift
//  AdTestApp
//
//  Created by Shafee Rehman on 01/07/2025.
//

import SwiftUI

struct InterstitialView: View {
    @State private var errorMessage: String?
    @State private var isLoaded: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Text("Interstitial Ad")
                    .foregroundStyle(.white)
                    .font(.title)
                    .bold()
                    .padding()
                Spacer()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                ZStack {
                    if !isLoaded {
                        ProgressView()
                    }
                    InterstitialViewRepresentable(
                        adSlotId: "interstitial",
                        errorCallback: { error in
                            self.errorMessage = error
                        },
                        isLoaded: { isLoaded in
                            self.isLoaded = isLoaded
                        }
                    )
                }
            }
            Spacer()
        }
        .background(Color("Background").ignoresSafeArea())
        .tint(.white)
    }
}

