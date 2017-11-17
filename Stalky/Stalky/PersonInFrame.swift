//
//  PersonInFrame.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import UIKit
import Sweeft

class PersonInFrame {
    
    let person: Response<Person>
    let area: CGRect
    
    init(person: Response<Person>, area: CGRect) {
        self.person = person
        self.area = area
    }
    
    convenience init(image: CIImage, area: CGRect) {
        // TODO create request here!
        let person = Person(name: "John Doe", link: nil)
        self.init(person: .successful(with: person), area: area)
    }
    
}

extension PersonInFrame {
    
    func moved(to area: CGRect) -> PersonInFrame {
        return PersonInFrame(person: person, area: area)
    }
    
}
