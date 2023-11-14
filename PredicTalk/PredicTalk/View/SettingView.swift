//
//  SettingView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var setting: Setting
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("言語", selection: $setting.selectedLanguage) {
                        ForEach(Language.allCases) {
                            Text($0.name)
                        }
                    }
                } header: {
                    Text("一般")
                }
                
                Section {
                    Toggle(isOn: $setting.convertToHiragana) {
                        Text("日本語を全てひらがなに変換する")
                    }
                } header: {
                    Text("日本語")
                }
            }
            .navigationTitle("設定")
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(Setting())
}
