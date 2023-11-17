//
//  PredicTalkApp.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

@main
struct PredicTalkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Setting())
                .onAppear {
                    AppDelegate.orientationLock = .all
                }
        }
    }
}
