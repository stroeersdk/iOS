//
//  ExampleAppApp.swift
//  ExampleApp
//
//  Created by Shafee Rehman on 14/10/2025.
//

import SwiftUI
import StroeerSDK

@main
struct ExampleAppApp: App {
    
    init() {
        Stroeer.setup(appName: "appDfpTest")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
