//
//  Language.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import Foundation

enum Language: Codable, CaseIterable, Identifiable {
    case italian
    case indonesian
    case ukrainian
    case dutch
    case spanish
    case thai
    case german
    case turkish
    case french
    case vietnamese
    case portuguese
    case russian
    case english_US
    case english_UK
    case korean
    case chinese_traditional
    case chinese_simplyfied
    case japanese
    
    var name: String {
        switch self {
        case .italian:
            return "イタリア語"
        case .indonesian:
            return "インドネシア語"
        case .ukrainian:
            return "ウクライナ語"
        case .dutch:
            return "オランダ語"
        case .spanish:
            return "スペイン語（スペイン）"
        case .thai:
            return "タイ語"
        case .german:
            return "ドイツ語"
        case .turkish:
            return "トルコ語"
        case .french:
            return "フランス語"
        case .vietnamese:
            return "ベトナム語"
        case .portuguese:
            return "ポルトガル語（ブラジル）"
        case .russian:
            return "ロシア語"
        case .english_US:
            return "英語（アメリカ）"
        case .english_UK:
            return "英語（イギリス）"
        case .korean:
            return "韓国"
        case .chinese_traditional:
            return "中国語（国語、繁体字）"
        case .chinese_simplyfied:
            return "中国語（普通話、簡体字）"
        case .japanese:
            return "日本語"
        }
    }
    
    var locale: Locale {
        switch self {
        case .italian:
            return Locale.init(identifier: "it_IT")
        case .indonesian:
            return Locale.init(identifier: "id")
        case .ukrainian:
            return Locale.init(identifier: "uk")
        case .dutch:
            return Locale.init(identifier: "nl_NL")
        case .spanish:
            return Locale.init(identifier: "es_ES")
        case .thai:
            return Locale.init(identifier: "th")
        case .german:
            return Locale.init(identifier: "de_DE")
        case .turkish:
            return Locale.init(identifier: "tr")
        case .french:
            return Locale.init(identifier: "fr_FR")
        case .vietnamese:
            return Locale.init(identifier: "vi")
        case .portuguese:
            return Locale.init(identifier: "pt_BR")
        case .russian:
            return Locale.init(identifier: "ru")
        case .english_US:
            return Locale.init(identifier: "en_US")
        case .english_UK:
            return Locale.init(identifier: "en_GB")
        case .korean:
            return Locale.init(identifier: "ko")
        case .chinese_traditional:
            return Locale.init(identifier: "zh_Hant")
        case .chinese_simplyfied:
            return Locale.init(identifier: "zh_Hans")
        case .japanese:
            return Locale.init(identifier: "ja_JP")
        }
    }
    
    var id: Self {
        self
    }
}
