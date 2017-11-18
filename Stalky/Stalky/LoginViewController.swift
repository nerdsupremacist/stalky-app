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

