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

        setupSubviewa()
    }

    private func setupSubviewa() {
        // Background
        let imageView = UIImageView(image: UIImage(named: "background")!)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // Title label
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 40)
        titleLabel.textColor = .red
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        titleLabel.animate(text: "Welcome to\nStalky", delay: 0.1, mainColor: .red, intermediateColor: .white)

        // About label
        let aboutLabel = UILabel()
        aboutLabel.text = "Icons provided by https://icons8.com/"
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.font = UIFont(name: "CourierNewPSMT", size: 12)
        aboutLabel.textColor = .red
        aboutLabel.textAlignment = .center
        view.addSubview(aboutLabel)
        aboutLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        aboutLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        // Login button
        let loginButton = LoginButton(readPermissions: [
            .publicProfile,
            .userFriends,
            .userAboutMe,
            .userBirthday,
            .userEducationHistory,
            .userWorkHistory,
            .userFriends,
            .userPhotos,
        ])
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        loginButton.widthAnchor.constraint(equalToConstant: 250).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: aboutLabel.topAnchor, constant: -40).isActive = true

        // Aim
        aim.translatesAutoresizingMaskIntoConstraints = false
        aim.backgroundColor = .clear
        view.addSubview(aim)
        aim.heightAnchor.constraint(equalToConstant: 200).isActive = true
        aim.widthAnchor.constraint(equalToConstant: 200).isActive = true
        aim.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 160).isActive = true
        aim.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor, constant: 75).isActive = true
        aim.layer.cornerRadius = 5
        aim.clipsToBounds = true
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


