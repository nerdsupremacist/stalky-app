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
import FacebookLogin

class PeopleViewController: UIViewController {
    
    var session: AVCaptureSession?
    var peopleView = UIView()
    
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
                        for: AVMediaType.video,
                        position: .back)
    }()
    
}

// MARK: - Set Up

extension PeopleViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sessionPrepare()
        session?.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let previewLayer = previewLayer else { return }
        view.layer.addSublayer(previewLayer)
        
        
        peopleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(peopleView)
        peopleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        peopleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        peopleView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        peopleView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        peopleView.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: -1))

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleThreeTaps))
        gestureRecognizer.numberOfTapsRequired = 3
        peopleView.addGestureRecognizer(gestureRecognizer)
    }

    @objc
    private func handleThreeTaps() {
        print("Recognized three taps")
        let loginManager = LoginManager()
        loginManager.logOut()
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
        
        detectionManager.updated(with: ciImage)
    }
    
}

extension PeopleViewController: PeopleDetectionManagerDelegate {
    
    func manager(_ manager: PeopleDetectionManager, didUpdate people: [PersonInFrame]) {
        people.filter({ $0.displayView.superview == nil }).forEach { person in
            
            // MARK: - First appearence
            
            self.peopleView.addSubview(person.displayView)
            person.displayView.layer.setAffineTransform(CGAffineTransform(scaleX: -1, y: -1))
            person.updateFrame(isFirstAppearance: true)
        }
    }
    
}

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
