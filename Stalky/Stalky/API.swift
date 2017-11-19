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

class FacebookAuth {
    let accessToken: AccessToken
    
    lazy var id: Response<String> = {
        return .new { setter in
            let connection = GraphRequestConnection()
            connection.add(GraphRequest(graphPath: "/me")) { httpResponse, result in
                switch result {
                    
                case .success(let response):
                    if let id = response.dictionaryValue?["id"] as? String {
                        setter.success(with: id)
                    } else {
                        setter.error(with: .noData)
                    }
                    
                case .failed(let error):
                    setter.error(with: .unknown(error: error))
                    
                }
            }
            connection.start()
        }
    }()
    
    init(accessToken: AccessToken) {
        self.accessToken = accessToken
    }
}

extension FacebookAuth: Auth {
    
    func apply(to request: URLRequest) -> Promise<URLRequest, APIError> {
        return id.map { (id: String) in
            let url = request.url.map { $0.appendingQuery(key: "id", value: id) }
            var request = request
            request.url = url
            request.addValue(self.accessToken.authenticationToken, forHTTPHeaderField: "Authorization")
            return request
        }
    }
    
}

class StalkyAPI: API {
    
    enum Endpoint: String, APIEndpoint {
        case user
        case identify
    }
    
    lazy static var shared: StalkyAPI = {
        return .init(baseURL: "http://165.227.130.27/api")
    }()
    
    lazy var auth: Auth = {
        guard let accessToken = AccessToken.current else {
            return NoAuth.standard
        }
        return FacebookAuth(accessToken: accessToken)
    }()
    
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
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
