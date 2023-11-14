//
//  HomeView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var setting: Setting
    @StateObject var speechRecognizer = SpeechRecognizer(language: .english)
    @State private var prediction = ""
    @State private var isRecording = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    Group {
                        Text("\(speechRecognizer.transcript) ").foregroundColor(.white) +
                        Text(prediction)
                            .foregroundColor(.secondary)
                    }
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .onTapGesture {
                    haptic.impactOccurred()
                    isRecording.toggle()
                }
            }
        }
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                startRecording()
            } else {
                speechRecognizer.stopTranscribing()
            }
        }
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            Task {
                do {
                    if !speechRecognizer.transcript.isEmpty {
                        try await prediction = APIRequest.shared.predict(sentence: newTranscript)
                    }
                } catch {
                    print(error)
                }
            }
        }
        .onAppear {
            speechRecognizer.initRecognizer(locale: setting.selectedLanguage.locale)
        }
        .onDisappear {
            speechRecognizer.stopTranscribing()
        }
    }
    
    func startRecording() {
        speechRecognizer.transcript = ""
        prediction = ""
        speechRecognizer.transcribe()
    }
}

#Preview {
    HomeView()
        .environmentObject(Setting())
}
