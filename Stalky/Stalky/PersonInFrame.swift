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
    private(set) var area: CGRect {
        didSet {
            updateFrame()
        }
    }
    
    lazy private(set) var displayView: AimView = {
        let view = AimView()
        view.backgroundColor = .clear
        return view
    }()
    
    init(person: Response<Person>, area: CGRect) {
        self.person = person
        self.area = area
    }
    
    convenience init(image: CIImage, area: CGRect) {
        self.init(person: Person.person(in: image, area: area), area: area)
    }
    
    deinit {
        let view = displayView
        DispatchQueue.main >>> {
            guard view.superview != nil else { return }
            view.removeFromSuperview()
        }
    }
    
    func updateFrame() {
        .main >>> {
            guard let superView = self.displayView.superview else {
                return
            }
            self.displayView.frame = self.area.scaled(to: superView.bounds.size).with(padding: 40)
            self.displayView.setNeedsDisplay()
        }
    }
    
}

extension PersonInFrame {
    
    func move(to area: CGRect) -> PersonInFrame {
        self.area = area
        return self
    }
    
}
