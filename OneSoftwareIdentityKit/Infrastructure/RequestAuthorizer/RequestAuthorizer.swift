//
//  RequestAuthorizer.swift
//  OneSoftwareIdentityKit
//
//  Created by Milen Halachev on 5/25/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

///A type that authorize instances of URLRequest
@MainActor
public protocol RequestAuthorizer {
    
    /**
     Authorizes an instance of URLRequest.
     
     Upon success, in the callback handler, the provided request will be authorized, otherwise the original request will be provided.
     
     - parameter request: The request to authorize.
     - parameter handler: The callback, executed when the authorization is complete. The callback takes 2 arguments - an URLRequest and an Error
     */
    func authorize(request: URLRequest, handler: @escaping (URLRequest, Error?) -> Void)
}

extension RequestAuthorizer {
    
    /**
     Asynchronously authorizes an instance of URLRequest.
     
     - parameter request: The request to authorize.
     
     - throws: if authorization fails
     
     - returns: The authorized request
     */
    @available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *)
    public func authorize(request: URLRequest) async throws -> URLRequest {
        
        return try await withCheckedThrowingContinuation { continuation in
            
            self.authorize(request: request) { urlRequest, error in
                
                if let error = error {
                    continuation.resume(throwing: error)
                }
                else {
                    continuation.resume(returning: urlRequest)
                }
            }
        }
    }
}

extension URLRequest {
    
    /**
     Authorize the receiver using a given authorizer. 
     
     Upon success, in the callback handler, the provided request will be an authorized copy of the receiver, otherwise a copy of the original receiver will be provided.
     
     - note: The implementation of this method simply calls `authorize` on the `authorizer`. For more information see `URLRequestAuthorizer`.
     
     - parameter authorizer: The authorizer used to authorize the receiver.
     - parameter handler: The callback, executed when the authorization is complete. The callback takes 2 arguments - an URLRequest and an Error
     
     */
    @MainActor
    public func authorize(using authorizer: RequestAuthorizer, handler: @escaping (URLRequest, Error?) -> Void) {
            authorizer.authorize(request: self, handler: handler)
    }
    
    /**
     Authorize the receiver using a given authorizer.
     
     - note: The implementation of this method simply calls `authorize` on the `authorizer`. For more information see `URLRequestAuthorizer`.
     
     - parameter authorizer: The authorizer used to authorize the receiver.
     
     - throws: if authorization fails
     
     - returns: The request, which will be an authorized copy of the receiver.
     
     */
    @available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *)
    @MainActor
    public func authorized(using authorizer: RequestAuthorizer) async throws -> URLRequest {
        
        return try await authorizer.authorize(request: self)
    }
    
    /**
     Asynchronously authorize the receiver using a given authorizer.
     
     - parameter authorizer: The authorizer used to authorize the receiver.
     
     - throws: An authorization error.
     */
    @available(iOS 13, tvOS 13, macOS 10.15, watchOS 6, *)
    @MainActor
    public mutating func authorize(using authorizer: RequestAuthorizer) async throws {
        
        self = try await authorized(using: authorizer)
    }
}

//a potentual implementation would be one that sets client id and secret into URL as query parameters
//another one would be one that sets client id and secret as 



