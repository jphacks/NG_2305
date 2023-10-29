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
                    Text(wordPredictor.nextSentence)
                        .foregroundColor(.secondary)
                }
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .onChange(of: speechRecognizer.transcript) { newTranscript in
                        wordPredictor.predictNextWord(sentence: newTranscript)
                    }
            }
            
            RecordButton(isRecording: $isRecording)
        }
    }
}

#Preview {
    ContentView()
}
