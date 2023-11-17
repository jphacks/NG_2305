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
    private let provider = MoyaProvider<APITarget>()
    
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
                        let successfullResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfullResponse.map(ChatCompletion.self)
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
                        let successfullResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfullResponse.map(ChatCompletion.self)
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
    
    public func upload(file: Data) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            if _Concurrency.Task.isCancelled {
                continuation.resume(throwing: CancellationError())
            }
            
            provider.request(.upload(file: file)) { result in
                if _Concurrency.Task.isCancelled {
                    continuation.resume(throwing: CancellationError())
                }
                
                switch result {
                case let .success(response):
                    do {
                        _ = try response.filterSuccessfulStatusCodes()
                        continuation.resume(returning: ())
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
                        let successfullResponse = try response.filterSuccessfulStatusCodes()
                        let decodedResponse = try successfullResponse.map(GooResponse.self)
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
