//
//  API.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/18/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Sweeft
import FacebookCore

struct File {
    let data: Data
    let name: String
    let mimeType: String
}

struct MultiformData {
    let parameters: [String : CustomStringConvertible]
    let boundary: String
    let files: [File]
}

extension MultiformData: DataSerializable {
    
    var contentType: String? {
        return "multipart/form-data; boundary=\(boundary)"
    }
    
    var data: Data? {
        let parametersData = parameters.reduce(Data()) { data, item in
            return data.appending(string: "--\(boundary)\r\n")
                       .appending(string: "Content-Disposition: form-data; name=\"\(item.key)\"\r\n\r\n")
                       .appending(string: "\(item.value)\r\n")
        }
        let fileData = files.reduce(parametersData) { data, item in
            return data.appending(string: "--\(boundary)\r\n")
                .appending(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(item.name)\"\r\n")
                .appending(string: "Content-Type: \(item.mimeType)\r\n\r\n")
                .appending(item.data)
                .appending(string: "\r\n")
        }
        return fileData.appending(string: "--\(boundary)--\r\n")
    }
    
}

extension Data {
    
    func appending(_ data: Data) -> Data {
        var output = self
        output.append(data)
        return output
    }
    
    func appending(string: String) -> Data {
        guard let data = string.data else {
            return self
        }
        return appending(data)
    }
    
}

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
        case user
        case identify
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
    
    var baseQueries: [String : String] {
        guard let userId = AccessToken.current?.userId else {
            return .empty
        }
        return ["id" : userId]
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
