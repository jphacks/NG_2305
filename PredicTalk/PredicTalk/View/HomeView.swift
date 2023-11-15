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
    @State private var isLoading = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width < geometry.size.height {
                VStack(spacing: 15) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.bar)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform")
                                Spacer()
                                Button {
                                    haptic.impactOccurred()
                                    isRecording.toggle()
                                } label: {
                                    Image(systemName: "mic.circle")
                                        .foregroundStyle(isRecording ? .accent : .primary)
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
                            .fill(.bar)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform.and.magnifyingglass")
                                Spacer()
                                if isLoading && isRecording {
                                    ProgressView()
                                }
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
                            .fill(.bar)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform")
                                Spacer()
                                Button {
                                    haptic.impactOccurred()
                                    isRecording.toggle()
                                } label: {
                                    Image(systemName: "mic.circle")
                                        .foregroundStyle(isRecording ? .accent : .primary)
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
                            .fill(.bar)
                        
                        VStack(spacing: 0) {
                            HStack {
                                Image(systemName: "waveform.and.magnifyingglass")
                                Spacer()
                                if isLoading && isRecording {
                                    ProgressView()
                                }
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
        .onChange(of: isRecording) { isRecording in
            if isRecording {
                startRecording()
            } else {
                stopRecording()
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
            print(isSilent)
            if isRecording {
                if isSilent {
                    if !transcription.isEmpty {
                        Task {
                            do {
                                let newPrediction = try await APIRequest.shared.predict(sentence: transcription)
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
                    prediction = ""
                }
            }
        }
        .onAppear {
            speechRecognizer.initRecognizer(locale: setting.selectedLanguage.locale)
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
