//
//  PeopleDetectionModel.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Vision
import UIKit

struct PersonInFrame {
    let person: Person
    let area: CGRect
}

extension PersonInFrame {
    
    func moved(to area: CGRect) -> PersonInFrame {
        return PersonInFrame(person: person, area: area)
    }
    
}

protocol PeopleDetectionManagerDelegate: AnyObject {
    func manager(_ manager: PeopleDetectionManager, didUpdate people: [PersonInFrame])
}

class PeopleDetectionManager {

    let faceDetection = VNDetectFaceRectanglesRequest()
    let faceDetectionRequest = VNSequenceRequestHandler()
    weak var delegate: PeopleDetectionManagerDelegate?
    var delegateQueue: DispatchQueue = .main
    
    private var person: PersonInFrame? {
        didSet {
            delegateQueue.async {
                let people = [self.person].flatMap { $0 }
                self.delegate?.manager(self, didUpdate: people)
            }
        }
    }
    
    init(delegate: PeopleDetectionManagerDelegate?) {
        self.delegate = delegate
    }
    
    func updated(with image: CIImage) {
        try? faceDetectionRequest.perform([faceDetection], on: image)
        guard let result = faceDetection.results?.first as? VNFaceObservation else {
            person = nil
            return
        }
        
        guard let person = person else {
            // TODO: Make Request
            
            let person = Person(name: "Mathias", link: nil)
            self.person = .init(person: person, area: result.boundingBox)
            return
        }
        
        self.person = person.moved(to: result.boundingBox)
    }
    
}

