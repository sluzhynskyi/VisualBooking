//
//  Login.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 17.12.2020.
//

import Foundation
import UIKit

class Login: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let navVC = UINavigationController(rootViewController: self)
        [loginButton].forEach { view.addSubview($0) }
        [loginButton].forEach { $0.addShadow(); $0.addCorners() }
        setupLayout()

    }
    @UsesAutoLayout
    var loginButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.setTitle("To home", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    @objc func loginButtonTapped(_ sender: StyledButton) {
        let homeVC = ViewController()
        navigationController?.pushViewController(homeVC, animated: true)

//        present(homeVC, animated: true, completion: nil)
//        performSegue(withIdentifier: "toHome", sender: homeVC)

    }

    func setupLayout() {
        let constraints = [
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
