//
//  PeopleDetectionModel.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Vision
import UIKit

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
            self.person = .init(image: image, area: result.boundingBox)
            return
        }
        
        self.person = person.moved(to: result.boundingBox)
    }
    
}

