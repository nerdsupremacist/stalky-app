//
//  ViewController.swift
//  Stalky
//
//  Created by Jana Pejić on 17.11.17..
//  Copyright © 2017. Jana Pejić. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController {

    private let loginManager = LoginManager()

    let loginButton = UIButton(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()

        if AccessToken.current == nil {
            let loginButton = LoginButton(readPermissions: [.publicProfile, .userFriends])
            loginButton.center = view.center
            loginButton.delegate = self
            view.addSubview(loginButton)
        } else {
            navigationController?.pushViewController(PeopleViewController(), animated: true)
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        dismiss(animated: true, completion: nil)
        navigationController?.pushViewController(PeopleViewController(), animated: true)
    }

    func loginButtonDidLogOut(_ loginButton: LoginButton) {

    }
}

