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
        view.startProgress()
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
            
            self?.displayView.color = .green
            self?.displayView.stopProgress()

            let name = "Name: \(person.name)\n"

            var additionalInfo: [String] = []
            var subadditionalInfo: [String] = []

            if let birthday = person.details.birthday {
                subadditionalInfo.append("Birthday: \(birthday)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }
            
            if let education = person.details.education?.last?.school.name {
                subadditionalInfo.append("Education: \(education)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }

            if let mutualEvents = person.details.mutualEvents {
                var mutualEventsString = ""
                for i in 0..<min(mutualEvents.count, 3) {
                    if mutualEventsString.isEmpty {
                        mutualEventsString.append(mutualEvents[i].name)
                    } else {
                        mutualEventsString.append(", \(mutualEvents[i].name)")
                    }
                }
                subadditionalInfo.append("Events: \(mutualEventsString)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }

            if let mutualBooks = person.details.mutualBooks {
                var mutualBooksString = ""
                for i in 0..<min(mutualBooks.count, 3) {
                    if mutualBooksString.isEmpty {
                        mutualBooksString.append(mutualBooks[i].name)
                    } else {
                        mutualBooksString.append(", \(mutualBooks[i].name)")
                    }
                }
                subadditionalInfo.append("Books: \(mutualBooksString)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }

            if let mutualMusic = person.details.mutualMusic {
                var mutualMusicString = ""
                for music in mutualMusic.array(withFirst: 3) {
                    if mutualMusicString.isEmpty {
                        mutualMusicString.append(music.name)
                    } else {
                        mutualMusicString.append(", \(music.name)")
                    }
                }
                subadditionalInfo.append("Music: \(mutualMusicString)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }
            
            if let lastSeenDate = person.details.lastSeenDate {
                let seenLocation = person.details.lastSeenLocation.map { "Near \($0) on " } ?? ""
                let dateString = lastSeenDate.string(using: "MM/dd/yyyy")
                subadditionalInfo.append("Last met: \(seenLocation)\(dateString)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }
            
            if let workPlace = person.details.work?.first {
                subadditionalInfo.append("Works at: \(workPlace.employer.name)")
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }
            
            if let relationShipStatus = person.details.relationShipStatus {
                subadditionalInfo.append(relationShipStatus)
                if subadditionalInfo.count == 3 {
                    additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
                    subadditionalInfo = []
                }
            }

            additionalInfo.append(subadditionalInfo.joined(separator: "\n"))
            subadditionalInfo = []

            let text = AimView.Text(name: name, additionalInfo: additionalInfo)
            self?.displayView.text = text
        }
        .onError(in: .main) { [weak self] error in
            
            self?.displayView.color = .white
            self?.displayView.stopProgress()
            
            print("Error: \(error)")
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
