//
//  Settings.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import Foundation

class Setting: ObservableObject {
    @Published var selectedLanguage: Language {
        didSet {
            UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "selectedLanguage")
        }
    }
    
    @Published var convertToHiragana: Bool {
        didSet {
            UserDefaults.standard.set(convertToHiragana, forKey: "convertToHiragana")
        }
    }
    
    @Published var apiMode: APIMode {
        didSet {
            UserDefaults.standard.set(apiMode.rawValue, forKey: "apiMode")
        }
    }
    
    @Published var selectedFileName: String {
        didSet {
            UserDefaults.standard.set(selectedFileName, forKey: "selectedFileName")
        }
    }
    
    @Published var selectedFileId: String {
        didSet {
            UserDefaults.standard.set(selectedFileId, forKey: "selectedFileId")
        }
    }
    
    @Published var assistantId: String {
        didSet {
            UserDefaults.standard.set(assistantId, forKey: "assistantId")
        }
    }

    init() {
        self.selectedLanguage = Language(rawValue: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "") ?? .english_US
        self.convertToHiragana = UserDefaults.standard.bool(forKey: "convertToHiragana")
        self.apiMode = APIMode(rawValue: UserDefaults.standard.string(forKey: "apiMode") ?? "") ?? .predict
        self.selectedFileName = UserDefaults.standard.string(forKey: "selectedFileName") ?? "なし"
        self.selectedFileId = UserDefaults.standard.string(forKey: "selectedFileId") ?? ""
        self.assistantId = UserDefaults.standard.string(forKey: "assistantId") ?? ""
    }
}

enum APIMode: String, CaseIterable, Identifiable {
    case predict
    case correct
    case assistant
    
    var name: String {
        switch self {
        case .predict:
            return "次文予測モード"
        case .correct:
            return "訂正モード"
        case .assistant:
            return "アシスタントモード"
        }
    }
    
    var id: Self {
        self
    }
}
