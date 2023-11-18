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

public struct Assistant: Decodable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let name: String?
    public let description: String?
    public let model: String
    public let instructions: String?
    public let tools: [RetrievalTool]
    public let file_ids: [String]
    public let metadata: [String: String]
}

public struct Run: Decodable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let thread_id: String
    public let assistant_id: String
    public let status: String
    public let last_error: LastError?
    public let expires_at: Int
    public let started_at: Int?
    public let cancelled_at: Int?
    public let failed_at: Int?
    public let completed_at: Int?
    public let model: String
    public let instructions: String
    public let tools: [RetrievalTool]
    public let file_ids: [String]
    public let metadata: [String: String]
}

public struct LastError: Decodable {
    public let code: String
    public let message: String
}

public struct RetrievalTool: Decodable {
    public let type: String
}

public struct MessageObject: Decodable {
    public let id: String
    public let object: String
    public let created_at: Int
    public let thread_id: String
    public let role: String
    public let content: [TextObject]
    public let assistant_id: String?
    public let run_id: String?
    public let file_ids: [String]
    public let metadata: [String: String]
}

public struct MessageList: Decodable {
    public let object: String
    public let data: [MessageObject]
    public let first_id: String
    public let last_id: String
    public let has_more: Bool
}

public struct TextObject: Decodable {
    public let type: String
    public let text: TextValue
}

public struct TextValue: Decodable {
    public let value: String
    public let annotations: [Citation]
}

public struct Citation: Decodable {
    public let type: String
    public let text: String
    public let file_citation: FileCitation
    public let start_index: Int
    public let end_index: Int
}

public struct FileCitation: Decodable {
    public let file_id: String
    public let quote: String
}

public struct DeletionStatus: Decodable {
    public let id: String
    public let object: String
    public let deleted: Bool
}

public struct GooResponse: Decodable {
    public let converted: String
    public let output_type: String
    public let request_id: String
}
