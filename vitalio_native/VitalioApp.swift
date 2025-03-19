//
//  VitalioApp.swift
//  Vitalio
//
//  Created by HID-18 on 11/03/25.
//

import SwiftUI

@main
struct VitalioApp: App {
    
    @ObservedObject private var route = Routing()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $route.navpath){
                ContentView()
            }
            .environmentObject(route)
         
        }
    }
}
