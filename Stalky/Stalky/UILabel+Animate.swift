//
//  UILabel+Animate.swift
//  Stalky
//
//  Created by Jana Pejić on 18.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit

extension UILabel {

    func animate(text: String, delay: TimeInterval) {
        guard let character = text.first else {
            guard let labelText = self.text else { return }
            self.animateCursor(text: labelText, delay: delay)
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.text = (self.text?.dropLast() ?? "").appending(String(character)).appending("_")
            self.animate(text: String(text.dropFirst()), delay: delay)
        }
    }

    func animateCursor(text: String, delay: TimeInterval) {
        // Animate cursor blinking
        let attributedString = NSMutableAttributedString(string: text)
        let rangeOfUnderScore = (text as NSString).range(of: "_")
        attributedString.addAttribute(.foregroundColor,
                                      value: UIColor.clear,
                                      range: rangeOfUnderScore)
        self.attributedText = attributedString

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let attributedString = NSMutableAttributedString(string: text)
            let rangeOfUnderScore = (text as NSString).range(of: "_")
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.white,
                                          range: rangeOfUnderScore)
            self.attributedText = attributedString
        }

    }

}
