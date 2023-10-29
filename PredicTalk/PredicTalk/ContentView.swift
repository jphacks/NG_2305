//
//  ContentView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

struct ContentView: View {
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var prediction = ""
    @State private var isRecording = false
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.horizontal) {
                    ScrollViewReader { reader in
                        Group {
                            Text("\(speechRecognizer.transcript) ").foregroundColor(.white) +
                            Text(prediction)
                                .foregroundColor(.secondary)
                        }
                        .id(0)
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        .onChange(of: speechRecognizer.transcript) { newTranscript in
                            Task {
                                do {
                                    if !newTranscript.isEmpty {
                                        try await prediction = APIRequest.shared.predict(sentence: newTranscript)
                                    }
                                } catch {
                                    print(error)
                                }
                            }
                            withAnimation(.easeInOut) {
                                reader.scrollTo(0)
                            }
                        }
                    }
                }
                .onTapGesture {
                    haptic.impactOccurred()
                    isRecording.toggle()
                }
                .onChange(of: isRecording) { isRecording in
                    isRecording ? speechRecognizer.transcribe() : speechRecognizer.stopTranscribing()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
