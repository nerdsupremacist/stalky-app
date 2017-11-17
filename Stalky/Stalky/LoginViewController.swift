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
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Logged in successfully")
        UIApplication.shared.keyWindow?.rootViewController = PeopleViewController()
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}

