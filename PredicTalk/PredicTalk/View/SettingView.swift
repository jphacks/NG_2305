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
                Picker("Transcription", selection: $setting.selectedLanguage) {
                    ForEach(Language.allCases) {
                        Text($0.name)
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(Setting())
}
