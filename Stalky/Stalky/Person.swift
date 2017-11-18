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
    let name: String
    let birthday: String?
    let dateOfFirstEncounter: String?
    let likes: [String]?
    let address: String?
    let education: String?
    let employer: String?
    let link: URL?

    init(name: String,
         birthday: Date? = nil,
         dateOfFirstEncounter: Date? = nil,
         likes: [String]? = nil,
         address: String? = nil,
         education: String? = nil,
         employer: String? = nil,
         link: URL? = nil) {

        self.name = name

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        if let birthday = birthday {
            self.birthday = dateFormatter.string(from: birthday)
        } else {
            self.birthday = nil
        }
        if let dateOfFirstEncounter = dateOfFirstEncounter {
            self.dateOfFirstEncounter = dateFormatter.string(from: dateOfFirstEncounter)
        } else {
            self.dateOfFirstEncounter = nil
        }

        self.likes = likes
        self.address = address
        self.education = education
        self.employer = employer
        self.link = link
    }
}

extension Person {
    
    static func person(in image: CIImage, area: CGRect, using api: StalkyAPI = .shared) -> Response<Person> {

        return async {
            let area = area.scaled(to: image.extent.size)
            guard let data = image.oriented(forExifOrientation: Int32(CGImagePropertyOrientation.leftMirrored.rawValue)).jpeg() else {
                
                throw APIError.noData
            }
            
            let name = "\(UUID().uuidString).jpg"
            
            let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            try data.write(to: url.appendingPathComponent(name))
            
            let file = File(data: data, name: name, mimeType: "application/octet-stream")
            let parameters = [
                "x": area.origin.x.description,
                "y": area.origin.y.description,
                "width": area.width.description,
                "height": area.height.description,
            ]
            return MultiformData(parameters: parameters, boundary: UUID().uuidString, files: [file])
        }.flatMap { (body: MultiformData) in
            return api.doRepresentedRequest(with: .post,
                                            to: .identify,
                                            body: body).map { (data: Data) in
                    print(data.string!)
                    return Person(name: "Jana Pejić",
                                  birthday: Calendar(identifier: .gregorian).date(from: DateComponents(year: 1991, month: 3, day: 14)),
                                  dateOfFirstEncounter: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2015, month: 4, day: 23)),
                                  likes: ["programming", "dancing"],
                                  address: "Munich, Germany",
                                  education: "TUM",
                                  employer: "NSA, CIA, FBI",
                                  link: nil)
                    
//                    let jsonDecoder = JSONDecoder()
//                    do {
//                        let result = try jsonDecoder.decode(Person.self, from: data)
//                        return .successful(with: result)
//                    } catch {
//                        return .errored(with: .unknown(error: error))
//                    }
                }
        }
    }
    
}

extension CGRect {
    
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
