//
//  ContentView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var wordPredictor = WordPredictor()
    @State private var transcript = "hello"
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Group {
                    Text("\(transcript) ") +
                    Text(wordPredictor.nextWord)
                        .foregroundColor(.secondary)
                }
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .onChange(of: transcript) { newTranscript in
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
