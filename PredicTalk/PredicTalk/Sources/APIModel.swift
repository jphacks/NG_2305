//
//  APIModel.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/29.
//

import Foundation

public struct ChatCompletion: Decodable {
    public let id: String
    public let choices: [Choice]
    public let created: Int
    public let model: String
    public let object: String
    public let usage: Usage
}

public struct Choice: Decodable {
    public let finish_reason: String
    public let index: Int
    public let message: Message
}

public struct Message: Decodable {
    public let content: String?
    public let function_call: FunctionCall?
    public let role: String
}

public struct FunctionCall: Decodable {
    public let arguments: String
    public let name: String
}

public struct Usage: Decodable {
    public let completion_tokens: Int
    public let prompt_tokens: Int
    public let total_tokens: Int
}

public struct File: Decodable {
    public let id: String
    public let bytes: Int
    public let created_at: Int
    public let filename: String
    public let object: String
    public let purpose: String
}

public struct GooResponse: Decodable {
    public let converted: String
    public let output_type: String
    public let request_id: String
}
