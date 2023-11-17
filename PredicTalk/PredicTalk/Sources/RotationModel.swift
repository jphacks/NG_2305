//
//  RotationModel.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/17.
//  https://seeking-star.com/prog/swiftui/device_orientation/
//

import Foundation
import UIKit

class RotationModel: NSObject, ObservableObject {
    // 画面を回転させる処理
    func rotate(screenOrientation :UIInterfaceOrientationMask) {
        AppDelegate.orientationLock = screenOrientation
        executeRotation(screenOrientation: screenOrientation)
    }
    
    func unRockScreenOrientation() {
        // 一旦現在の画面の向きに直す
        switch UIDevice.current.orientation {
        case .portrait:
            self.rotate(screenOrientation: .portrait)
        case .landscapeLeft:
            // UIDeviceOrientationとUIInterfaceOrientationMaskとでは向きが逆？
            self.rotate(screenOrientation: .landscapeRight)
        case .landscapeRight:
            // UIDeviceOrientationとUIInterfaceOrientationMaskとでは向きが逆？
            self.rotate(screenOrientation: .landscapeLeft)
        default:
            self.rotate(screenOrientation: .portrait)
        }
        
        // 画面向きを固定している状態を解除する
        self.rotate(screenOrientation: .all)
    }
    
    // 画面の回転処理を実行
    private func executeRotation(screenOrientation :UIInterfaceOrientationMask) {
        // 画面のUIWindowを取得
        guard let window = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first?.windows.filter({ $0.isKeyWindow }).first else {
            return
        }
        
        // SupportedInterfaceOrientationsを更新する
        window.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        
        if screenOrientation == .all {
            return
        }
        
        guard let windowScene = window.windowScene else {
            return
        }
        // 画面の向きの状態を更新して、向きを固定する
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: screenOrientation)) { error in
            print(error)
        }
    }
}
