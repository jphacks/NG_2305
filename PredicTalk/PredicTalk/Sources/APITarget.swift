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
}

extension APITarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.openai.com/v1")!
    }
    
    public var path: String {
        return "/chat/completions"
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var task: Task {
        switch self {
        case .predict(let sentence):
            var data: [String: Any] = [:]
            
            data["model"] = "gpt-3.5-turbo"
            
            let sysMsg = ["role": "system", "content": "Generate a continuation of the text entered. Also, please keep the sentences as short as possible. Make sure that the sentences you generate are natural when combined with the input sentences."]
            let usrMsg = ["role": "assistant", "content": sentence]
            let msgs = [sysMsg, usrMsg]
            
            data["messages"] = msgs
            data["temperature"] = 0
            
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var sampleData: Data {
        let url = Bundle.main.url(forResource: "MockResponse", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    
    public var headers: [String : String]? {
        return ["Authorization": "Bearer \(API_KEY)"]
    }
}
