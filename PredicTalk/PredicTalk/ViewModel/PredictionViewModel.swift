//
//  PredictionViewModel.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/11/30.
//

import SwiftUI

class PredictionViewModel: ObservableObject {
    @Published var model = PredictionModel()
    
    private let apiRequest = APIRequest.shared
    
    func predict(sentence: String) async throws {
        model.prediction = try await apiRequest.predict(sentence: sentence)
    }
    
    func predictHiragana(sentence: String) async throws {
        let predictionKanji = try await apiRequest.predict(sentence: sentence)
        model.prediction = try await apiRequest.toHiragana(sentence: predictionKanji)
    }
    
    func correct(sentence: String) async throws {
        model.prediction = try await apiRequest.correct(sentence: sentence)
    }
    
    func correctHiragana(sentence: String) async throws {
        let correctKanji = try await apiRequest.correct(sentence: sentence)
        model.prediction = try await apiRequest.toHiragana(sentence: correctKanji)
    }
}
