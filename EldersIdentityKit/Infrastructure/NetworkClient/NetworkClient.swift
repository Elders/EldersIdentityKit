//
//  NetworkClient.swift
//  EldersIdentityKit
//
//  Created by Milen Halachev on 4/12/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

///A type that performs network requests
@MainActor
public protocol NetworkClient {
    
    ///Performs a request and execute a completion handler when it is done
    func perform(_ request: URLRequest, completion: @escaping @Sendable (NetworkResponse) -> Void)
    
    func perform(_ request: URLRequest) async throws -> NetworkResponse
}

