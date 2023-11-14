//
//  HomeView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var setting: Setting
    @StateObject var speechRecognizer = SpeechRecognizer(language: .english_US)
    @State private var transcription = ""
    @State private var prediction = ""
    @State private var isRecording = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                Group {
                    Text("\(transcription) ") +
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
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                startRecording()
            } else {
                stopRecording()
            }
        }
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            Task {
                do {
                    if !speechRecognizer.transcript.isEmpty {
                        let newPrediction = try await APIRequest.shared.predict(sentence: newTranscript)
                        if setting.selectedLanguage == .japanese && setting.convertToHiragana {
                            transcription = try await APIRequest.shared.toHiragana(sentence: newTranscript)
                            prediction = try await APIRequest.shared.toHiragana(sentence: newPrediction)
                        } else {
                            transcription = newTranscript
                            prediction = newPrediction
                        }
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
    
    func stopRecording() {
        speechRecognizer.stopTranscribing()
        transcription = ""
        prediction = ""
    }
}

#Preview {
    HomeView()
        .environmentObject(Setting())
}
