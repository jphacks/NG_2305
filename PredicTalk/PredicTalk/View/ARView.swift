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
        }
        .fullScreenCover(isPresented: $isPresented) {
            ZStack {
                Text("LandscapeLockedView")
            }
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
