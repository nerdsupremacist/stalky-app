//
//  PeopleViewController.swift
//  Stalky
//
//  Created by Mathias Quintero on 11/17/17.
//  Copyright © 2017 Jana Pejić. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class PeopleViewController: UIViewController {
    
    var session: AVCaptureSession?
    var shapeView = UIView()
    let shapeLayer = CAShapeLayer()
    
    lazy var detectionManager: PeopleDetectionManager = {
        return PeopleDetectionManager(delegate: self)
    }()
    
    lazy var previewLayer: AVCaptureVideoPreviewLayer? = {
        guard let session = self.session else { return nil }
        
        var previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }()
    
    var device: AVCaptureDevice? = {
        return .default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                        for: AVMediaType.video, position: .back)
    }()
    
}

// MARK: - Set Up

extension PeopleViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionPrepare()
        session?.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.frame
        shapeLayer.frame = view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let previewLayer = previewLayer else { return }
        
        view.layer.addSublayer(previewLayer)
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2.0
        
        //needs to filp coordinate system for Vision
        shapeLayer.setAffineTransform(CGAffineTransform(scaleX: -1, y: -1))
        
        view.layer.addSublayer(shapeLayer)
        
        shapeView.backgroundColor = .white
        shapeView.frame = .zero
        
        view.addSubview(shapeView)
    }
    
}

extension PeopleViewController {
    
    
    func sessionPrepare() {
        session = AVCaptureSession()
        guard let session = session, let captureDevice = device else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            session.beginConfiguration()
            
            if session.canAddInput(deviceInput) {
                session.addInput(deviceInput)
            }
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings = [
                String(kCVPixelBufferPixelFormatTypeKey) : Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            
            output.alwaysDiscardsLateVideoFrames = true
            
            if session.canAddOutput(output) {
                session.addOutput(output)
            }
            
            session.commitConfiguration()
            output.setSampleBufferDelegate(self, queue: .global())
        } catch {
            print("can't setup session")
        }
    }
    
}

// MARK: - Image Capture

extension PeopleViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        let attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [String : Any]?)
        
        //leftMirrored for front camera
        let ciImageWithOrientation = ciImage.oriented(forExifOrientation: Int32(UIImageOrientation.leftMirrored.rawValue))
        
        detectionManager.updated(with: ciImageWithOrientation)
    }
    
}

extension PeopleViewController: PeopleDetectionManagerDelegate {
    
    func manager(_ manager: PeopleDetectionManager, didUpdate people: [PersonInFrame]) {
        
        // TODO: Display rectangles with data
        
        guard let person = people.first else {
            shapeView.frame = .zero
            return
        }
        
        UIView.animate(withDuration: 0.00001) {
            self.shapeView.frame = person.area.scaled(to: self.view.bounds.size)
        }
    }
    
}

import UIKit

extension CGRect {
    
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(
            x: self.origin.x * size.width,
            y: self.origin.y * size.height,
            width: self.size.width * size.width,
            height: self.size.height * size.height
        )
    }
    
}
