//
//  APIRequest.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/29.
//

import Foundation
import Moya

public final class APIRequest {
    public static let shared = APIRequest()
    
//    private let provider = MoyaProvider<APITarget>(stubClosure: MoyaProvider.immediatelyStub)
    private var provider = MoyaProvider<APITarget>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
    
    private init() {}
    
    public func predict(sentence: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.predict(sentence: sentence)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(ChatCompletion.self)
                        continuation.resume(returning: decodedResponse.choices.first!.message.content!)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func correct(sentence: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.correct(sentence: sentence)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(ChatCompletion.self)
                        continuation.resume(returning: decodedResponse.choices.first!.message.content!)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func upload(file: Data, fileName: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.upload(file: file, fileName: fileName)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(File.self)
                        continuation.resume(returning: decodedResponse.id)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func createAssistant(fileId: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.createAssistant(fileId: fileId)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(Assistant.self)
                        continuation.resume(returning: decodedResponse.id)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func createThreadAndRun(assistantId: String, sentence: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.createThreadAndRun(assistantId: assistantId, sentence: sentence)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(Run.self)
                        continuation.resume(returning: decodedResponse.thread_id)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func getMessage(threadId: String) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.listMessages(threadId: threadId)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(MessageList.self)
                        if decodedResponse.data[0].role == "assistant" {
                            continuation.resume(returning: decodedResponse.data[0].content[0].text.value)
                        } else {
                            continuation.resume(throwing: APIError.noAnswerError)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func deleteFile(fileId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.deleteFile(fileId: fileId)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(DeletionStatus.self)
                        if decodedResponse.deleted {
                            continuation.resume(returning: ())
                        } else {
                            continuation.resume(throwing: APIError.deletionError)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func deleteAssistant(assistantId: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.deleteAssistant(assistantId: assistantId)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(DeletionStatus.self)
                        if decodedResponse.deleted {
                            continuation.resume(returning: ())
                        } else {
                            continuation.resume(throwing: APIError.deletionError)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
    
    public func toHiragana(sentence: String) async throws -> String {
        try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.toHiragana(sentence: sentence)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        let successfulResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfulResponse.map(GooResponse.self)
                        continuation.resume(returning: decodedResponse.converted)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(moyaError):
                    continuation.resume(throwing: moyaError)
                }
            }
        }
    }
}

enum APIError: Error {
    case noAnswerError
    case deletionError
    
    var message: String {
        switch self {
        case .noAnswerError:
            return "アシスタントからの回答を取得できませんでした"
        case .deletionError:
            return "削除できませんでした"
        }
    }
}
