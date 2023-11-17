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
    case correct(sentence: String)
    case upload(file: Data)
    case toHiragana(sentence: String)
}

extension APITarget: TargetType {
    public var baseURL: URL {
        switch self {
        case .predict, .correct, .upload:
            return URL(string: "https://api.openai.com/v1")!
        case .toHiragana:
            return URL(string: "https://labs.goo.ne.jp/api")!
        }
    }
    
    public var path: String {
        switch self {
        case .predict, .correct:
            return "/chat/completions"
        case .upload:
            return "/files"
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
            
            guard let fileURL = Bundle.main.url(forResource: "Predict", withExtension: "md"), let prompt = try? String(contentsOf: fileURL, encoding: .utf8) else {
                fatalError("読み込み出来ません")
            }
            
            let sysMsg = ["role": "system", "content": prompt]
            let usrMsg = ["role": "user", "content": sentence]
            let msgs = [sysMsg, usrMsg]
            
            data["messages"] = msgs
            data["temperature"] = 0
            
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .correct(let sentence):
            var data: [String: Any] = [:]
                
            data["model"] = "gpt-4-1106-preview"
                
            guard let fileURL = Bundle.main.url(forResource: "Correct", withExtension: "md"), let prompt = try? String(contentsOf: fileURL, encoding: .utf8) else {
                fatalError("読み込み出来ません")
            }
                
            let sysMsg = ["role": "system", "content": prompt]
            let usrMsg = ["role": "user", "content": sentence]
            let msgs = [sysMsg, usrMsg]
                
            data["messages"] = msgs
            data["temperature"] = 0
                
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .upload(let file):
            let multipartData = [MultipartFormData(provider: .data(file), name: "file", fileName: "file.pdf", mimeType: "application/pdf")]
            let urlParameters = ["purpose": "assistants"]
            
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
        case .toHiragana(let sentence):
            let data: [String: Any] = ["app_id": APP_ID, "sentence": sentence, "output_type": "hiragana"]
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .predict, .correct:
            let url = Bundle.main.url(forResource: "ChatResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        case .upload:
            let url = Bundle.main.url(forResource: "UploadFileResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        case .toHiragana:
            let url = Bundle.main.url(forResource: "HiraganaResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .predict, .correct, .upload:
            return ["Authorization": "Bearer \(API_KEY)"]
        case .toHiragana:
            return ["Content-Type": "application/json"]
        }
    }
}
