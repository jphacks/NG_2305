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
    @State private var fileNameInfo = ""
    @State private var transcription = ""
    @State private var prediction = ""
    @State private var isRecording = false
    @State private var isLoading = false
    @State private var isTransparent = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform")
                                    .foregroundStyle(.accent)
                                Spacer()
                                Button {
                                    haptic.impactOccurred()
                                    isRecording.toggle()
                                } label: {
                                    Image(systemName: "mic.circle")
                                        .foregroundStyle(isRecording ? .red : .accent)
                                }
                            }
                            .padding(10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(transcription)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(10)
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundStyle(.accent)
                                    .opacity(isTransparent ? 0 : 1)
                                
                                Spacer()
                                
                                Text(fileNameInfo)
                                    .lineLimit(1)
                                    .foregroundStyle(.gray)
                                    .font(.headline)
                            }
                            .padding(10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(prediction)
                                    .foregroundStyle(.accent)
                            }
                            .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3.5, alignment: .topLeading)
                            .padding(10)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 3.5)
                }
                .font(.title)
                .padding(20)
            } else {
                HStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform")
                                    .foregroundStyle(.accent)
                                Spacer()
                                Button {
                                    haptic.impactOccurred()
                                    isRecording.toggle()
                                } label: {
                                    Image(systemName: "mic.circle")
                                        .foregroundStyle(isRecording ? .red : .accent)
                                }
                            }
                            .padding(10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(transcription)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(10)
                        }
                    }
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "brain.head.profile")
                                    .foregroundStyle(.accent)
                                    .opacity(isTransparent ? 0 : 1)
                                
                                Spacer()
                                
                                Text(fileNameInfo)
                                    .lineLimit(1)
                                    .foregroundStyle(.gray)
                                    .font(.headline)
                            }
                            .padding(10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                Text(prediction)
                                    .foregroundStyle(.accent)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(10)
                        }
                    }
                }
                .font(.title)
                .padding(20)
            }
        }
        .bold()
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                startRecording()
            } else {
                stopRecording()
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
        .onChange(of: speechRecognizer.transcript) { newTranscript in
            if !newTranscript.isEmpty {
                if setting.selectedLanguage == .japanese && setting.convertToHiragana {
                    Task {
                        do {
                            transcription = try await APIRequest.shared.toHiragana(sentence: newTranscript)
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    transcription = newTranscript
                }
            }
        }
        .onChange(of: speechRecognizer.isSilent) { isSilent in
            if isRecording {
                if isSilent {
                    if !transcription.isEmpty {
                        Task {
                            do {
                                var newPrediction: String
                                switch setting.apiMode {
                                case .predict:
                                    newPrediction = try await APIRequest.shared.predict(sentence: transcription)
                                case .correct:
                                    newPrediction = try await APIRequest.shared.correct(sentence: transcription)
                                    if newPrediction.contains("$") {
                                        newPrediction.removeAll(where:{ $0 == "$"})
                                        speechRecognizer.stopTranscribing()
                                        speechRecognizer.transcribe()
                                    }
                                case .assistant:
                                    let threadId = try await APIRequest.shared.createThreadAndRun(assistantId: setting.assistantId, sentence: transcription)
                                    sleep(8)
                                    newPrediction = try await APIRequest.shared.getMessage(threadId: threadId)
                                }
                                
                                if setting.selectedLanguage == .japanese && setting.convertToHiragana {
                                    prediction = try await APIRequest.shared.toHiragana(sentence: newPrediction)
                                } else {
                                    prediction = newPrediction
                                }
                                isLoading = false
                            } catch {
                                print(error)
                                isLoading = false
                            }
                        }
                    }
                } else {
                    isLoading = true
                }
            }
        }
        .onAppear {
            speechRecognizer.initRecognizer(locale: setting.selectedLanguage.locale)
            if setting.apiMode == .assistant && setting.selectedFileName != "なし" {
                fileNameInfo = setting.selectedFileName
            } else {
                fileNameInfo = ""
            }
        }
        .onDisappear {
            isRecording = false
            isLoading = false
        }
    }
    
    func startRecording() {
        transcription = ""
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
