//
//  APIRequest.swift
//  PredicTalk
//
//  Created by 青原光 on 2023/10/29.
//

import Foundation
import Moya

public final class Request {
    public static let shared = Request()
    
//    private let provider = MoyaProvider<APIs>(stubClosure: MoyaProvider.immediatelyStub)
    private let provider = MoyaProvider<APIs>()
    
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
}
