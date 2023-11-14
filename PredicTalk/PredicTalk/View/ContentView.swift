//
//  ContentView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack(spacing: 0) {
                        Image(systemName: "bubble.left.and.text.bubble.right")
                        Text("Home")
                    }
                }
            SettingView()
                .tabItem {
                    VStack(spacing: 0) {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Setting())
}
