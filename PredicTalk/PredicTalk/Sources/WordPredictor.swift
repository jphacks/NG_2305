//
//  WordPredictor.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import Foundation
import CoreML

import Foundation
import Accelerate
import CoreML

class WordPredictor: ObservableObject {
    @Published var nextSentence: String = ""
    
    private let model = try! GPT2()
    private let tokenizer = GPT2Tokenizer()
    
    func predictNextWord(sentence: String) {
        let inputTokens = tokenizer.encode(text: sentence)
        let seqLen = inputTokens.count
        let input = MLMultiArray.from(inputTokens)
        
        do {
            let output = try model.prediction(context: input)
            let outputArray = MLMultiArray.toIntArray(output.sentence_2).dropFirst(seqLen).map { $0 }
            nextSentence = tokenizer.decode(tokens: outputArray)
        } catch {
            return
        }
    }
}
