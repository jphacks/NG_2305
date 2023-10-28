//
//  ContentView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import SwiftUI

struct ContentView: View {
    @State private var transcript = "hello"
    @State private var prediction = "world"
    @State private var isRecording = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text("\(transcript) \(prediction)")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            
            RecordButton(isRecording: $isRecording)
        }
    }
}

#Preview {
    ContentView()
}
