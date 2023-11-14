//
//  Settings.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/14.
//

import Foundation

class Setting: ObservableObject {
    @Published var selectedLanguage: Language = .english
}
