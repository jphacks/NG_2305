//
//  LandscapeLockedView.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/16.
//

import SwiftUI

class LandscapeLockedViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let windowScene = view.window?.windowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape)) { error in
            print(error)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let windowScene = view.window?.windowScene else { return }
        windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait)) { error in
            print(error)
        }
    }
}

struct LandscapeLockedView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LandscapeLockedViewController {
        return LandscapeLockedViewController()
    }

    func updateUIViewController(_ uiViewController: LandscapeLockedViewController, context: Context) {
        // 更新が必要な場合の処理
    }
}
