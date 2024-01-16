//
//  SpeechRecognitionView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/30.
//

import SwiftUI

struct SpeechRecognitionView: View {
    @EnvironmentObject var setting: Setting
    @EnvironmentObject var viewModel: SpeechRecognitionViewModel
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
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
                        viewModel.model.isRecording.toggle()
                    } label: {
                        Image(systemName: "mic.circle")
                            .foregroundStyle(viewModel.model.isRecording ? .red : .accent)
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    Text(viewModel.model.transcription)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .font(.title)
            .bold()
            .padding()
        }
        .onAppear() {
            viewModel.initRecognizer(locale: setting.selectedLanguage.locale)
        }
        .onDisappear {
            viewModel.stopTranscribing()
        }
        .onChange(of: viewModel.model.isRecording) { isRecording in
            if isRecording {
                viewModel.startTranscribing()
            } else {
                viewModel.stopTranscribing()
            }
        }
    }
}

#Preview {
    SpeechRecognitionView()
        .environmentObject(Setting())
        .environmentObject(SpeechRecognitionViewModel(language: .english_US))
}