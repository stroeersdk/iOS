//
//  ContentView.swift
//  ExampleApp
//
//  Created by Shafee Rehman on 14/10/2025.
//

import SwiftUI
import StroeerSDK_Consent

struct ContentView: View {
    
    @State private var path = NavigationPath()
    let consentDelegate: StroeerConsentPublisherDelegate = ConsentHandler()
    @StateObject private var consent = StroeerConsent()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 175, height: 35)
                        .padding(6)
                    Spacer()
                }
                
                Spacer()
                
                Button {
                    path.append(NavDestination.Banner)
                } label: {
                    Text("Banner")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 175, height: 70)
                        .background(Color.white.gradient.opacity(0.1))
                }
                
                Button {
                    path.append(NavDestination.Interstitial)
                } label: {
                    Text("Interstitial")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 175, height: 70)
                        .background(Color.white.gradient.opacity(0.1))
                }
                
                Button {
                    if let windowScene = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                        consent.collect(viewController: rootViewController, delegate: consentDelegate)
                    }
                } label: {
                    Text("Give Consent")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 175, height: 70)
                        .background(Color.white.gradient.opacity(0.1))
                }
                
                Button {
                    if let windowScene = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                        consent.showPrivacyManager(viewController: rootViewController, delegate: consentDelegate)
                    }
                } label: {
                    Text("Privacy Manager")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 175, height: 70)
                        .background(Color.white.gradient.opacity(0.1))
                }
                
                Spacer()
            }
            .background(
                Color("Background")
            )
            .navigationDestination(for: NavDestination.self) { destination in
                switch destination {
                case .Banner:
                    BannerView()
                case .Interstitial:
                    InterstitialView()
                }
            }
        }
    }
}

enum NavDestination: Hashable {
    case Banner
    case Interstitial
}

class ConsentHandler : StroeerConsentPublisherDelegate {
    /// called when there's a consent Message to be shown or before the PM is shown
    func onSPUIReady(){
        
    }
    
    /// called when the consent ui is closed
    func onSPUIFinished(){
        
    }
    
    /// the `onError` function can be called at any moment during the SDKs lifecycle
    func onError(error: StroeerConsentError){
        
    }
}
