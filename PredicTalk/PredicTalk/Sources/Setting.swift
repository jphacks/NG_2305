//
//  Settings.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import Foundation

class Setting: ObservableObject {
    @Published var selectedLanguage: Language = .english_US
    @Published var convertToHiragana: Bool = true
    @Published var apiMode: APIMode = .predict
    @Published var selectedFileName = "なし"
    @Published var selectedFileId = ""
}

enum APIMode: CaseIterable, Identifiable {
    case predict
    case correct
    
    var name: String {
        switch self {
        case .predict:
            return "次文予測モード"
        case .correct:
            return "訂正モード"
        }
    }
    
    var id: Self {
        self
    }
}
