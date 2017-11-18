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
    fileprivate var personSetter: Response<Person>.Setter.Weak?
    
    var isAnimatingMovement = false
    var appearancesCounter = 1
    
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
    
    init(area: CGRect) {
        self.area = area
        var personSetter: Response<Person>.Setter.Weak?
        self.person = .new { setter in
            personSetter = setter.weak()
        }
        self.personSetter = personSetter
        
        person.onSuccess(in: .main) { [weak self] person in
            
            var text = "Name: \(person.name)\n"
            
            if let birthday = person.birthday {
                text.append("\n")
                text.append("Birthday: \(birthday)")
            }
            
            if let dateOfFirstEncounter = person.dateOfFirstEncounter {
                text.append("\n")
                text.append("Met on: \(dateOfFirstEncounter)")
                
            }
            if let likes = person.likes {
                text.append("\n")
                text.append("Likes: \(likes.joined(separator: ", "))")
                
            }
            if let address = person.address {
                text.append("\n")
                text.append("Address: \(address)")
                
            }
            if let education = person.education {
                text.append("\n")
                text.append("Education: \(education)")
                
            }
            if let employer = person.employer {
                text.append("\n")
                text.append("Employer: \(employer)")
                
            }
            
            self?.displayView.animate(text: text)
        }
        .onError { error in
            if case .invalidStatus(_, let data) = error {
                print(data!.string!)
            }
        }
    }
    
    deinit {
        let view = displayView
        person.cancel()
        DispatchQueue.main >>> {
            guard view.superview != nil else { return }
            view.removeFromSuperview()
        }
    }
    
    func received(newImage: CIImage) {
        appearancesCounter += 1
        guard let personSetter = personSetter, appearancesCounter > 3 else {
            return
        }
        self.personSetter = nil
        Person.person(in: newImage, area: area).onResult { result in
            personSetter.write(result: result)
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
