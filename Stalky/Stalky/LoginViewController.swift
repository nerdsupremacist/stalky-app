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

    private let aim = AimView()

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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "CourierNewPS-BoldMT", size: 40)
        label.textColor = .red
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
        label.animate(text: "Welcome to\nStalky", delay: 0.1, mainColor: .red, intermediateColor: .white)

        let about = UILabel()
        about.text = "Icons provided by\nhttps://icons8.com/"
        about.translatesAutoresizingMaskIntoConstraints = false
        about.font = UIFont(name: "CourierNewPSMT", size: 20)
        about.textColor = .red
        about.numberOfLines = 0
        about.textAlignment = .center
        view.addSubview(about)
        about.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        about.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        aim.translatesAutoresizingMaskIntoConstraints = false
        aim.backgroundColor = .clear
        view.addSubview(aim)
        aim.heightAnchor.constraint(equalToConstant: 120).isActive = true
        aim.widthAnchor.constraint(equalToConstant: 120).isActive = true
        aim.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70).isActive = true
        aim.centerXAnchor.constraint(equalTo: label.centerXAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.7, delay: 0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.aim.alpha = 0
        }, completion: nil)
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


