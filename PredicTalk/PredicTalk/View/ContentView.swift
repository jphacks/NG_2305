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
                        Image(systemName: "platter.2.filled.iphone")
                        Text("スマートフォン")
                    }
                }
            
            ARView()
                .tabItem {
                    VStack(spacing: 0) {
                        Image(systemName: "eyeglasses")
                        Text("AR")
                    }
                }
            
            SettingView()
                .tabItem {
                    VStack(spacing: 0) {
                        Image(systemName: "gearshape")
                        Text("設定")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Setting())
}
