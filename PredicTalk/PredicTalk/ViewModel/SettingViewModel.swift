//
//  SettingViewModel.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/30.
//

import Foundation

class SettingViewModel: ObservableObject {
    @Published var settingModel = SettingModel()
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        if let data = userDefaults.data(forKey: "settingModel") {
            do {
                let decoder = JSONDecoder()
                settingModel = try decoder.decode(SettingModel.self, from: data)
            } catch {
                print("Failed to decode data: \(error)")
            }
        }
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(settingModel)
            userDefaults.set(encodedData, forKey: "settingModel")
        } catch {
            print("Failed to encode data: \(error)")
        }
    }
}
