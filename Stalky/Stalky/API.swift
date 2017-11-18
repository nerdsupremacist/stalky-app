//
//  API.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/18/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Sweeft
import FacebookCore

struct FacebookAuth {
    let accessToken: AccessToken
}

extension FacebookAuth: Auth {
    
    func apply(to request: URLRequest) -> Promise<URLRequest, APIError> {
        var request = request
        request.addValue(accessToken.authenticationToken, forHTTPHeaderField: "Authorization")
        return .successful(with: request)
    }
    
}

struct StalkyAPI: API {
    
    enum Endpoint: String, APIEndpoint {
        case user = "user/"
        case find
    }
    
    static var shared: StalkyAPI {
        return .init(baseURL: "http://165.227.130.27/api")
    }
    
    let baseURL: String
    
    var auth: Auth {
        guard let accessToken = AccessToken.current else {
            return NoAuth.standard
        }
        return FacebookAuth(accessToken: accessToken)
    }
}

extension StalkyAPI {
    
    @discardableResult
    func registerUser() -> Response<JSON> {
        guard let accessToken = AccessToken.current else {
            return .errored(with: .cannotPerformRequest)
        }
        let body: JSON = [
            "id": accessToken.userId,
        ]
        return doJSONRequest(with: .post, to: .user, body: body)
    }
    
}
