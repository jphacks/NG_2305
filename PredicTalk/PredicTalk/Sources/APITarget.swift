//
//  APITarget.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/29.
//

import Foundation
import Moya

public enum APITarget: Decodable {
    case predict(sentence: String)
    case toHiragana(sentence: String)
}

extension APITarget: TargetType {
    public var baseURL: URL {
        switch self {
        case .predict:
            return URL(string: "https://api.openai.com/v1")!
        case .toHiragana:
            return URL(string: "https://labs.goo.ne.jp/api")!
        }
    }
    
    public var path: String {
        switch self {
        case .predict:
            return "/chat/completions"
        case .toHiragana:
            return "/hiragana"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .predict(let sentence):
            var data: [String: Any] = [:]
            
            data["model"] = "gpt-4-1106-preview"
            
            let sysMsg = ["role": "system", "content": "Generate a continuation of the text entered. Also, please keep the sentences as short as possible. Make sure that the sentences you generate are natural when combined with the input sentences."]
            let usrMsg = ["role": "assistant", "content": sentence]
            let msgs = [sysMsg, usrMsg]
            
            data["messages"] = msgs
            data["temperature"] = 0
            
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .toHiragana(let sentence):
            let data: [String: Any] = ["app_id": APP_ID, "sentence": sentence, "output_type": "hiragana"]
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .predict:
            let url = Bundle.main.url(forResource: "ChatResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        case .toHiragana:
            let url = Bundle.main.url(forResource: "HiraganaResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .predict:
            return ["Authorization": "Bearer \(API_KEY)"]
        case .toHiragana:
            return ["Content-Type": "application/json"]
        }
    }
}
