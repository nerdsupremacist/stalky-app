//
//  API.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/18/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Sweeft
import FacebookCore

struct StalkyAPI: API {
    
    enum Endpoint: String, APIEndpoint {
        case user
        case find
    }
    
    static var shared: StalkyAPI {
        return .init(baseURL: "http://swifty.cloudapp.net/api")
    }
    
    let baseURL: String
}

extension StalkyAPI {
    
    @discardableResult
    func registerUser() -> Response<JSON> {
        guard let accessToken = AccessToken.current else {
            return .errored(with: .cannotPerformRequest)
        }
        let body: JSON = [
            "id": accessToken.userId,
            "access_token": accessToken.authenticationToken,
        ]
        return doJSONRequest(with: .post, to: .user, body: body)
    }
    
}
