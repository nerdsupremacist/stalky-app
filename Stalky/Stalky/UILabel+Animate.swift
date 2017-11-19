//
//  UILabel+Animate.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

extension UILabel {

    typealias CompletionHandler = () -> ()

    func animate(text: String, delay: TimeInterval, mainColor: UIColor, intermediateColor: UIColor, completion: CompletionHandler? = nil) {
        guard let character = text.first else {
            guard let labelText = self.text else { return }
            self.animateCursor(text: labelText,
                               delay: delay,
                               mainColor: mainColor,
                               intermediateColor: intermediateColor,
                               completion: completion)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.text = (self.text?.dropLast() ?? "").appending(String(character)).appending("_")
            self.animate(text: String(text.dropFirst()),
                         delay: delay,
                         mainColor: mainColor,
                         intermediateColor: intermediateColor,
                         completion: completion)
        }
    }

    func animateCursor(text: String, delay: TimeInterval, mainColor: UIColor, intermediateColor: UIColor, completion: CompletionHandler? = nil) {
        // Animate cursor blinking
        let attributedString = NSMutableAttributedString(string: text)
        let rangeOfUnderScore = (text as NSString).range(of: "_")
        attributedString.addAttribute(.foregroundColor,
                                      value: intermediateColor,
                                      range: rangeOfUnderScore)
        self.attributedText = attributedString

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let attributedString = NSMutableAttributedString(string: text)
            let rangeOfUnderScore = (text as NSString).range(of: "_")
            attributedString.addAttribute(.foregroundColor,
                                          value: mainColor,
                                          range: rangeOfUnderScore)
            self.attributedText = attributedString

            completion?()
        }

    }

}
