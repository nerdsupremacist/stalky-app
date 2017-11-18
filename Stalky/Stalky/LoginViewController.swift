//
//  ViewController.swift
//  Stalky
//
//  Created by Jana Pejić on 17.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit
import FacebookLogin

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let loginButton = LoginButton(readPermissions: [.publicProfile, .userFriends])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)

        printText()
    }

    private func printText() {
        let label = UILabel()
        label.textColor = .magenta
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "CourierNewPSMT", size: 20)
        label.numberOfLines = 0
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        view.bringSubview(toFront: label)
        label.animate(text: "JANA BANANA", delay: 0.1)
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        guard case .success = result else {
            return
        }
        
        print("Logged in successfully")
        StalkyAPI.shared.registerUser().onResult { result in
            print(result)
        }
        UIApplication.shared.keyWindow?.rootViewController = PeopleViewController()
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}

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
                                      value: UIColor.white,
                                      range: rangeOfUnderScore)
        self.attributedText = attributedString

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let attributedString = NSMutableAttributedString(string: text)
            let rangeOfUnderScore = (text as NSString).range(of: "_")
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.magenta,
                                          range: rangeOfUnderScore)
            self.attributedText = attributedString
        }

    }

}

