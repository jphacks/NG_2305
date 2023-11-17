//
//  ARView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/15.
//

import SwiftUI

struct ARView: View {
    @ObservedObject var rotationModel: RotationModel
    @State private var isPresented = false
    
    init() {
        rotationModel = RotationModel()
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Button {
                    isPresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                        Text("ARモードを開始")
                            .foregroundStyle(.black)
                    }
                }
                .frame(width: 200, height: 50)
                
                Text("⚠︎ ARモードを修了するには、画面を2回タップしてください。")
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isPresented) {
            ARModeView()
                .onTapGesture(count: 2) {
                    isPresented = false
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        rotationModel.rotate(screenOrientation: .landscapeLeft)
                    }
                }
                .onDisappear {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        rotationModel.unRockScreenOrientation()
                    }
                }
        }
    }
}

#Preview {
    ARView()
}
