//
//  AccessTokenResponse.swift
//  EldersIdentityKit
//
//  Created by Milen Halachev on 5/24/17.
//  Copyright © 2017 Milen Halachev. All rights reserved.
//

import Foundation

//https://tools.ietf.org/html/rfc6749#section-5.1
@MainActor
public struct AccessTokenResponse: Sendable {
    
    public var accessToken: String
    public var tokenType: String
    public var expiresIn: TimeInterval?
    public var refreshToken: String?
    public var scope: Scope?
    
    //Contains any additional parameters of the access token response.
    public var additionalParameters: [String: Any]
    
    //Contains all parameteres, including additional
    public var parameters: [String: Any] {
        
        var parameters: [String: Any] = [:]
        parameters[ParameterKey.accessToken] = self.accessToken
        parameters[ParameterKey.tokenType] = self.tokenType
        parameters[ParameterKey.expiresIn] = self.expiresIn
        parameters[ParameterKey.refreshToken] = self.refreshToken
        parameters[ParameterKey.scope] = self.scope?.rawValue
        
        return parameters.merging(self.additionalParameters, uniquingKeysWith: { $1 })
    }
    
    public init(accessToken: String, tokenType: String, expiresIn: TimeInterval?, refreshToken: String?, scope: Scope?) {
        
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = expiresIn
        self.refreshToken = refreshToken
        self.scope = scope
        
        self.additionalParameters = [:]
    }
    
    public init(parameters: [String: Any]) throws {
        
        var parameters = parameters
        
        guard
        let accessToken = parameters.removeValue(forKey: ParameterKey.accessToken) as? String,
        let tokenType = parameters.removeValue(forKey: ParameterKey.tokenType) as? String
        else {
            
            throw EldersIdentityKitError.Reason.invalidAccessTokenResponse
        }
        
        self.accessToken = accessToken
        self.tokenType = tokenType
        self.expiresIn = parameters.removeValue(forKey: ParameterKey.expiresIn) as? TimeInterval
        self.refreshToken = parameters.removeValue(forKey: ParameterKey.refreshToken) as? String
        
        if let scopeRawValue = parameters.removeValue(forKey: ParameterKey.scope) as? String {
        
            self.scope = Scope(rawValue: scopeRawValue)
        }
        else {
            
            self.scope = nil
        }
        
        self.additionalParameters = parameters
    }
    
    ///The date when this object has been created - used to determine whenever the access token has expired
    private let responseCreationDate = Date()
    
    ///determine whenever the access token has expired
    @MainActor
    public var isExpired: Bool {
        
        //if expiration time interval is not provided - call the expiration handler
        guard let expiresIn = self.expiresIn else {
            
            return type(of: self).expirationHandler(self)
        }
        
        //compare the time interval since the creation of this object with the expiration time interval provided
        let timeIntervalPassed = Date().timeIntervalSince(self.responseCreationDate)
        return timeIntervalPassed >= expiresIn
    }
}

extension AccessTokenResponse {
    
    public struct ParameterKey {
        
        public static let accessToken = "access_token"
        public static let tokenType = "token_type"
        public static let expiresIn = "expires_in"
        public static let refreshToken = "refresh_token"
        public static let idToken = "id_token"
        public static let scope = "scope"
    }
}

extension AccessTokenResponse {
    
    ///Provide a custom expiration handler in case the server does not return the expiration time interval.
    ///-returns: true if the token is expired, otherwise false. Default behaviour returns false.
    @MainActor public static var expirationHandler: (AccessTokenResponse) -> Bool = { _ in
        
        //the authorization server SHOULD provide the expiration time via other means or document the default value.
        //Assume the token has not expired. In case it is - the failure of the request will indicate that the token is invalid, that should result in retry from client perspective.
        return false
    }
}
