//
//  DefaultNetoworkClient.swift
//  MHIdentityKit
//
//  Created by Milen Halachev on 5/26/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#endif

///A default implementation of a NetworkClient, used internally
class DefaultNetoworkClient: NetworkClient {
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
    
    
    private let session = URLSession(configuration: .ephemeral)
    
    func perform(_ request: URLRequest, completion: @escaping @Sendable(NetworkResponse) -> Void) {
        
        #if os(iOS)
            let application = UIApplication.shared
            var id = UIBackgroundTaskIdentifier.invalid
            id = application.beginBackgroundTask(withName: "MHIdentityKit.DefaultNetoworkClient.\(#function).backgroundTask") {
                
                let description = NSLocalizedString("Unable to complete network request", comment: "The description of the network error produced when the background time has expired")
                let reason = NSLocalizedString("Backgorund time has expired.", comment: "The reason of the network error produced when the background time has expired")
                let error = MHIdentityKitError.general(description: description, reason: reason)
                
                completion(NetworkResponse(data: nil, response: nil, error: error))
                application.endBackgroundTask(id)
                id = UIBackgroundTaskIdentifier.invalid
            }
        #endif
        
        let task = self.session.dataTask(with: request) { (data, response, error) in
            
            completion(NetworkResponse(data: data, response: response, error: error))
            
            #if os(iOS)
            DispatchQueue.main.sync {
                application.endBackgroundTask(id)
                id = UIBackgroundTaskIdentifier.invalid
            }
            #endif
        }
        
        task.resume()
    }
    
    deinit {
        
        self.session.invalidateAndCancel()
    }
}

///The shared instance of the default network client, used internally
@MainActor
public let _defaultNetworkClient: NetworkClient = DefaultNetoworkClient()
