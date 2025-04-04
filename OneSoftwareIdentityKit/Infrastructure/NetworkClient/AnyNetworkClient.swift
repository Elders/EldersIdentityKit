//
//  AnyNetworkClient.swift
//  OneSoftwareIdentityKit
//
//  Created by Milen Halachev on 11.08.18.
//  Copyright © 2018 Milen Halachev. All rights reserved.
//

import Foundation

///A default, closure based implementation of NetworkClient
public struct AnyNetworkClient: NetworkClient {
    
    public let handler: (_ request: URLRequest, _ completion: @escaping  @Sendable @MainActor (NetworkResponse) -> Void) -> Void
    
    public init(handler: @escaping (_ request: URLRequest, _ completion: @escaping @Sendable (NetworkResponse) -> Void) -> Void) {
        
        self.handler = handler
    }
    
    public init(other userAgent: NetworkClient) {
        
        self.handler = userAgent.perform(_:completion:)
    }
    
    public func perform(_ request: URLRequest, completion: @escaping @Sendable @MainActor (NetworkResponse) -> Void) {
        
        self.handler(request, completion)
    }
}
