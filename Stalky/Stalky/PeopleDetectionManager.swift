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

protocol PeopleDetectionManagerDelegate: AnyObject {
    func manager(_ manager: PeopleDetectionManager, didUpdate people: [PersonInFrame])
}

class PeopleDetectionManager {

    let faceDetection = VNDetectFaceRectanglesRequest()
    let faceDetectionRequest = VNSequenceRequestHandler()
    weak var delegate: PeopleDetectionManagerDelegate?
    
    init(delegate: PeopleDetectionManagerDelegate?) {
        self.delegate = delegate
    }
    
    func updated(with image: CIImage) {
        try? faceDetectionRequest.perform([faceDetection], on: image)
        guard let results = faceDetection.results as? [VNFaceObservation], results.isEmpty else {
            return
        }
        
    }
    
}

