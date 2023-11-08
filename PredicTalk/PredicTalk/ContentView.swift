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
    @State private var timer: Timer?
    
    let haptic = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { reader in
                        Group {
                            Text("\(speechRecognizer.transcript) ").foregroundColor(.white) +
                            Text(prediction)
                                .foregroundColor(.secondary)
                        }
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .onChange(of: speechRecognizer.transcript) { newTranscript in
                            timer?.invalidate()
                            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { timer in
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
                        }
                    }
                }
                .onTapGesture {
                    haptic.impactOccurred()
                    isRecording.toggle()
                }
                .onChange(of: isRecording) { isRecording in
                    if isRecording {
                        speechRecognizer.transcript = ""
                        prediction = ""
                        speechRecognizer.transcribe()
                    } else {
                        speechRecognizer.stopTranscribing()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
