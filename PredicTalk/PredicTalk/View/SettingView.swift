//
//  SettingView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingView: View {
    @EnvironmentObject var setting: Setting
    @State private var isDocumentPickerPresented = false
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("モード", selection: $setting.apiMode) {
                        ForEach(APIMode.allCases) {
                            Text($0.name)
                        }
                    }
                    
                    Picker("言語", selection: $setting.selectedLanguage) {
                        ForEach(Language.allCases) {
                            Text($0.name)
                        }
                    }
                } header: {
                    Text("一般")
                }
                
                Section {
                    HStack {
                        Text("ファイル")
                        
                        Spacer()
                        
                        if !isLoading {
                            Text(setting.selectedFileName)
                                .foregroundStyle(.gray)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    Button {
                        isDocumentPickerPresented = true
                    } label: {
                        Text("ファイルを選択")
                    }
                } header: {
                    Text("アシスタントモード")
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
        .fileImporter(
            isPresented: $isDocumentPickerPresented,
            allowedContentTypes: [UTType.pdf],
            onCompletion: { result in
                isLoading = true
                do {
                    let selectedFile = try result.get()
                    Task {
                        try await setPDF(url: selectedFile)
                        setting.apiMode = .assistant
                        isLoading = false
                    }
                } catch {
                    print(error)
                    isLoading = false
                }
            }
        )
    }
    
    func setPDF(url: URL) async throws {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileName = url.lastPathComponent
            let destinationURL = documentsDirectory.appendingPathComponent(fileName)
            setting.selectedFileName = destinationURL.lastPathComponent

            _ = url.startAccessingSecurityScopedResource()
            let data = try Data(contentsOf: url)
            url.stopAccessingSecurityScopedResource()
            
            let fileId = try await APIRequest.shared.upload(file: data, fileName: fileName)
            setting.assistantId = try await APIRequest.shared.createAssistant(fileId: fileId)
        }
    }
}

#Preview {
    SettingView()
        .environmentObject(Setting())
}
