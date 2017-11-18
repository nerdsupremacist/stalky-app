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
    var isAnimatingMovement = true
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
        person.onSuccess { person in
            DispatchQueue.main.async {
                self.displayView.animate(text: person.name)
            }
        }
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
    
    func updateFrame(isFirstAppearance: Bool = false) {
        .main >>> {
            guard let superView = self.displayView.superview else {
                return
            }
            self.isAnimatingMovement = true
            if isFirstAppearance {
                self.displayView.frame = self.area.scaled(to: superView.bounds.size).with(padding: 150)
                self.displayView.setNeedsDisplay()
            }
            let duration = isFirstAppearance ? 0.1 : 0.05
            UIView.animate(withDuration: duration, animations: {
                self.displayView.frame = self.area.scaled(to: superView.bounds.size).with(padding: 40)
            }) { success in
                self.isAnimatingMovement = false
            }
            self.displayView.setNeedsDisplay()
        }
    }
    
}

extension PersonInFrame {
    
    func move(to area: CGRect) -> PersonInFrame {
        guard !isAnimatingMovement else { return self }
//        guard self.area.distance(to: area) > 0.06 else { return self }
        self.area = area
        return self
    }
    
}
