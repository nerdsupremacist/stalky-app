//
//  Person.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Sweeft
import UIKit

struct Person: Codable {
    
    struct Details: Codable {
        
        struct EducationEntry: Codable {
            
            struct School: Codable {
                let id: String
                let name: String
            }
            
            struct Concentration: Codable {
                let id: String
                let name: String
            }
            
            let id: String
            let type: String
            let concentration: [Concentration]?
            let school: School
        }
        
        struct MutualEventEntry: Codable {
            let id: String
            let name: String
        }
        
        struct MutualBookEntry: Codable {
            let id: String
            let name: String
        }
        
        struct MutualMusicEntry: Codable {
            let id: String
            let name: String
        }
        
        let birthday: String?
        let education: [EducationEntry]?
        let mutual_events: [MutualEventEntry]?
        let mutual_books: [MutualBookEntry]?
        let mutual_music: [MutualMusicEntry]?
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "Friend Name"
        case details = "Friend Info"
    }
    
    let name: String
    let details: Details
}

extension Person {
    
    static func person(in image: CIImage, area: CGRect, using api: StalkyAPI = .shared) -> Response<Person> {

        let area = area.translating(by: .init(dx: 1.0, dy: 1.0))
                       .scaled(to: .init(width: 0.5, height: 0.5))
                       .scaled(to: image.extent.size)
        
        return async {
            guard let data = image.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.leftMirrored.rawValue)).jpeg() else {
                
                throw APIError.noData
            }
            
            
            let name = "\(UUID().uuidString).jpg"
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            try data.write(to: url.appendingPathComponent(name))
            
            let file = File(data: data, name: name, mimeType: "application/octet-stream")
            return MultiformData(parameters: [:], boundary: UUID().uuidString, files: [file])
        }.flatMap { (body: MultiformData) in
            
            let queries = [
                "x": area.origin.x,
                "y": area.origin.y,
                "width": area.width,
                "height": area.height,
            ]
            
            print(queries)
            
            return api.doRepresentedRequest(with: .post,
                                            to: .identify,
                                            queries: queries,
                                            body: body).flatMap { (data: Data) in
                    print(data.string!)
                    return async {
                        
                        let jsonDecoder = JSONDecoder()
                        let dateFormatter = DateFormatter()
                        dateFormatter.calendar = Calendar(identifier: .gregorian)
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
                        return try jsonDecoder.decode(Person.self, from: data)
                    }
                }
        }
    }
    
}

extension CGRect {
    
    func translating(by vector: CGVector) -> CGRect {
        return CGRect(x: origin.x + vector.dx,
                      y: origin.y + vector.dy,
                      width: width,
                      height: height)
    }
    
    func with(padding: CGFloat) -> CGRect {
        return CGRect(x: max(self.origin.x - padding, 0),
                      y: max(self.origin.y - padding, 0),
                      width: self.width + 2.0 * padding,
                      height: self.height + 2.0 * padding)
    }
    
}

extension CIImage {
    
    func jpeg() -> Data? {
        guard let eaglContext = EAGLContext(api: .openGLES2) else {
            return nil
        }
        let ciContext = CIContext(eaglContext: eaglContext)
        guard let outputImageRef = ciContext.createCGImage(self, from: self.extent) else {
            return nil
        }
        let uiImage = UIImage.init(cgImage: outputImageRef, scale: 0.5, orientation: .up)
        return UIImageJPEGRepresentation(uiImage, 0.5)
    }
    
}
