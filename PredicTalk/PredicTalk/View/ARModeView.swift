//
//  ARModeView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/17.
//

import SwiftUI

struct ARModeView: View {
    @EnvironmentObject var setting: Setting
    @StateObject var speechRecognizer = SpeechRecognizer(language: .english_US)
    @State private var prediction = ""
    @State private var isLoading = false
    @State private var isTransparent = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                HStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .foregroundStyle(.accent)
                        .opacity(isTransparent ? 0 : 1)
                    Text(prediction)
                        .foregroundStyle(.white)
                }
                .font(.largeTitle)
            }
        }
        .onChange(of: speechRecognizer.isSilent) { isSilent in
            if isSilent {
                let transcription = speechRecognizer.transcript
                if !transcription.isEmpty {
                    Task {
                        do {
                            let newPrediction: String
                            switch setting.apiMode {
                            case .predict:
                                newPrediction = try await APIRequest.shared.predict(sentence: transcription)
                            case .correct:
                                newPrediction = try await APIRequest.shared.correct(sentence: transcription)
                            }
                            
                            if setting.selectedLanguage == .japanese && setting.convertToHiragana {
                                prediction = try await APIRequest.shared.toHiragana(sentence: newPrediction)
                            } else {
                                prediction = newPrediction
                            }
                            isLoading = false
                        } catch {
                            print(error)
                        }
                    }
                }
            } else {
                isLoading = true
            }
        }
        .onChange(of: isLoading) { isLoading in
            if isLoading {
                withAnimation(Animation.easeInOut(duration: 0.5).repeatForever()) {
                    isTransparent.toggle()
                }
            } else {
                isTransparent = false
            }
        }
        .onAppear {
            speechRecognizer.initRecognizer(locale: setting.selectedLanguage.locale)
            startRecording()
        }
        .onDisappear {
            stopRecording()
            isLoading = false
        }
    }
    
    func startRecording() {
        prediction = ""
        speechRecognizer.transcribe()
    }
    
    func stopRecording() {
        speechRecognizer.stopTranscribing()
        prediction = ""
    }
}

#Preview {
    ARModeView()
        .environmentObject(Setting())
}
