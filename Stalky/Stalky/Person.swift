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
    let link: URL?
}

extension Person {
    
    static func person(in image: CIImage, area: CGRect) -> Response<Person> {
//        let cropped = image.cropped(to: area.with(padding: 20.0))
//        guard let data = UIImagePNGRepresentation(.init(ciImage: cropped)) else {
//            return
//        }
        
        let person = Person(name: "John Doe", link: nil)
        return .successful(with: person)
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
