//
//  ExampleApp_CocoapodsApp.swift
//  ExampleApp-Cocoapods
//
//  Created by Shafee Rehman on 12/10/2026.
//

import SwiftUI
import StroeerSDK

@main
struct ExampleApp_CocoapodsApp: App {
    init() {
        Stroeer.setup(appName: "appDfpTest")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
