//
//  SettingModel.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/30.
//

struct SettingModel: Codable {
    var apiMode = APIMode.predict
    var selectedLanguage = Language.english_US
    var convertToHiragana = true
}
