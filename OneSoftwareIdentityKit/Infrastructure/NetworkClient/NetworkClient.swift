//
//  NetworkClient.swift
//  OneSoftwareIdentityKit
//
//  Created by Milen Halachev on 4/12/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

///A type that performs network requests
@MainActor
public protocol NetworkClient {
    
    ///Performs a request and execute a completion handler when it is done
    func perform(_ request: URLRequest, completion: @escaping @Sendable @MainActor (NetworkResponse) -> Void)
    
   
}

extension NetworkClient {
    
    func perform(_ request: URLRequest) async throws -> NetworkResponse {
        
        return try await withCheckedThrowingContinuation { continuation in
            // Call the callback-based version of `perform`
            perform(request) { response in
                // Handle success or failure
                if let error = response.error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: response)
                }
            }
        }
    }
}

