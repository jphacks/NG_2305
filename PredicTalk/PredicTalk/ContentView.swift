//
//  ContentView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wordPredictor = WordPredictor()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Group {
                    Text("\(speechRecognizer.transcript) ") +
                    Text(wordPredictor.nextWord)
                        .foregroundColor(.secondary)
                }
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .onChange(of: speechRecognizer.transcript) { newTranscript in
                        wordPredictor.predictNextWord(sentence: newTranscript)
                    }
            }
            .onTapGesture {
                isRecording.toggle()
            }
            .onChange(of: isRecording) { isRecording in
                isRecording ? speechRecognizer.transcribe() : speechRecognizer.stopTranscribing()
            }
        }
    }
}

#Preview {
    ContentView()
}
