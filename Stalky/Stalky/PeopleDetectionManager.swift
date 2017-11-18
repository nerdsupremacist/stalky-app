//
//  PeopleDetectionModel.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import Vision
import UIKit

let boundingBoxChangeTolerance: CGFloat = 10.0

private enum StateChangeResult {
    case remainedFromLastFrame(previous: PersonInFrame, VNFaceObservation)
    case new(VNFaceObservation)
}

extension StateChangeResult {
    
    func person(in image: CIImage) -> PersonInFrame {
        
        switch self {
            
        case .new(let observation):
            return PersonInFrame(image: image, area: observation.boundingBox)
            
        case .remainedFromLastFrame(let previous, let observation):
            return previous.move(to: observation.boundingBox)
        }
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
    
    private var people = [PersonInFrame]() {
        didSet {
            let people = self.people
            delegateQueue.async {
                self.delegate?.manager(self, didUpdate: people)
            }
        }
    }
    
    init(delegate: PeopleDetectionManagerDelegate?) {
        self.delegate = delegate
    }
    
    func updated(with image: CIImage) {
        try? faceDetectionRequest.perform([faceDetection], on: image)
        let results = faceDetection.results?.flatMap { $0 as? VNFaceObservation } ?? []
        print("\(results.count) faces in frame")
        let changes = stateChanges(from: results)
        self.people = changes.map { $0.person(in: image) }
    }
    
}

extension PeopleDetectionManager {
    
    fileprivate func stateChanges(from results: [VNFaceObservation]) -> [StateChangeResult] {
        return results.map { result in
            guard let previous = self.people.argmax({ $0.area.distance(to: result.boundingBox) }),
                previous.area.distance(to: result.boundingBox) < boundingBoxChangeTolerance else {
                    
                return .new(result)
            }
            return .remainedFromLastFrame(previous: previous, result)
        }
    }
    
}

extension CGRect {
    
    func distance(to other: CGRect) -> CGFloat {
        let paths: [KeyPath<CGRect, CGFloat>] = [
            \.origin.x,
            \.origin.y,
            \.size.width,
            \.size.height,
        ]
        let differences = paths.map { self[keyPath: $0] - other[keyPath: $0] }
        return differences.reduce(0.0) { $0 + $1 }
    }
    
}

