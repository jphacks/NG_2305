//
//  WordPredictor.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/28.
//

import Foundation
import CoreML

class WordPredictor: ObservableObject {
    @Published var nextWord = ""
    
    private let MAX_SEQ_LEN = 20
    private let VOCAB_LEN = 30522
    private let MASK_TOKEN_ID = 103
    
    private let model = try! MobileBert()
    private let tokenizer = BertTokenizer()
    
    func predictNextWord(sentence: String) {
        let input = "[CLS] \(sentence) [MASK] [SEP]"
        let inputTokens = tokenizer.tokenizeToIds(text: input)
        
        var inputArray = try! MLMultiArray(shape: [1, MAX_SEQ_LEN as NSNumber], dataType: .int32)
        var maskTokenIndex = -1
        
        for i in 0..<inputArray.count {
            if i < inputTokens.count {
                inputArray[i] = inputTokens[i] as NSNumber
                if inputTokens[i] == MASK_TOKEN_ID { maskTokenIndex = i }
            } else { inputArray[i] = 0 }
        }
        
        var top5Tokens:[Int]
        
        do {
            let output = try model.prediction(input: inputArray)
            let outputArray = MLMultiArray.toDoubleArray(output.Identity)
            top5Tokens = Math.topK(
                arr: Array(outputArray[maskTokenIndex * VOCAB_LEN..<(maskTokenIndex + 1) * VOCAB_LEN]),
                k: 5).0
        } catch {
            return
        }
        
        for token in top5Tokens {
            let unTokenized = tokenizer.unTokenize(tokens: [token])[0]
            if unTokenized.isAlphabet() {
                nextWord = unTokenized
                return
            }
        }
    }
}
