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
    case upload(file: Data, fileName: String)
    case createAssistant(fileId: String)
    case createThreadAndRun(assistantId: String, sentence: String)
    case listMessages(threadId: String)
    case toHiragana(sentence: String)
}

extension APITarget: TargetType {
    public var baseURL: URL {
        switch self {
        case .predict, .correct, .upload, .createAssistant, .createThreadAndRun, .listMessages:
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
        case .createAssistant:
            return "/assistants"
        case .createThreadAndRun:
            return "/threads/runs"
        case .listMessages(let threadId):
            return "/threads/\(threadId)/messages"
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
        case .upload(let file, let fileName):
            let fileData = MultipartFormData(provider: .data(file), name: "file", fileName: "\(fileName).pdf", mimeType: "application/pdf")
            let parametersData = MultipartFormData(provider: .data("assistants".data(using: .utf8)!), name: "purpose")
            let multipartData = [fileData, parametersData]

            return .uploadMultipart(multipartData)
        case .createAssistant(let fileId):
            var data: [String: Any] = [:]
                
            data["model"] = "gpt-4-1106-preview"
                
            guard let fileURL = Bundle.main.url(forResource: "Assistant", withExtension: "md"), let prompt = try? String(contentsOf: fileURL, encoding: .utf8) else {
                fatalError("読み込み出来ません")
            }
            
            data["instructions"] = prompt
            data["tools"] = [["type": "retrieval"]]
            data["file_ids"] = [fileId]
                
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .createThreadAndRun(let assistantId, let sentence):
            var data: [String: Any] = [:]
            data["assistant_id"] = assistantId
            data["thread"] = ["messages": [["role": "user", "content": sentence]]]
            
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        case .toHiragana(let sentence):
            let data: [String: Any] = ["app_id": APP_ID, "sentence": sentence, "output_type": "hiragana"]
            return .requestParameters(parameters: data, encoding: JSONEncoding.default)
        default:
            return .requestPlain
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
        case .createAssistant:
            let url = Bundle.main.url(forResource: "CreateAssistantResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        case .createThreadAndRun:
            let url = Bundle.main.url(forResource: "CreateThreadAndRunResponse", withExtension: "json")!
            return try! Data(contentsOf: url)
        case .listMessages:
            let url = Bundle.main.url(forResource: "ListMessagesResponse", withExtension: "json")!
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
        case .createAssistant, .createThreadAndRun, .listMessages:
            return ["Content-Type": "application/json", "Authorization": "Bearer \(API_KEY)", "OpenAI-Beta": "assistants=v1"]
        case .toHiragana:
            return ["Content-Type": "application/json"]
        }
    }
}
