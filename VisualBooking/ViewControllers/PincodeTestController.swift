//
//  PincodeTestController.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 18.12.2020.
//

import Foundation
import UIKit
import PinCodeTextField
import Firebase
class PincodeTestController: UIViewController {
    let defaults = UserDefaults.standard
    var phoneNumber: String!
    var code: String!
    @UsesAutoLayout
    var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    @UsesAutoLayout
    var pincodeInputTextField: PinCodeTextField = {
        let textField = PinCodeTextField()
        textField.characterLimit = 6
        textField.fontSize = 26
        textField.textColor = .black
        textField.underlineColor = .black
        textField.placeholderText = "XXXXXX"
        textField.keyboardType = .phonePad
        return textField
    }()

    @UsesAutoLayout
    var verificationButton: StyledButton = {
        let button = StyledButton()
        button.setTitle("CONTINUE", for: .normal)
        button.addTarget(self, action: #selector(verificationButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        pincodeInputTextField.keyboardAppearance = .light
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Enter code"
        let attributedText = NSMutableAttributedString(string: "An SMS code was sent to", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.gray])

        attributedText.append(NSAttributedString(string: "\n\n\(phoneNumber!)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.black]))

        [descriptionTextView, pincodeInputTextField, verificationButton].forEach { view.addSubview($0) }
        [verificationButton].forEach { $0.addShadow(); $0.addCorners() }
        pincodeInputTextField.prepareForInterfaceBuilder()
        pincodeInputTextField.becomeFirstResponder()
        descriptionTextView.attributedText = attributedText
        descriptionTextView.textAlignment = .center
        setupLayout()


    }

    @objc func verificationButtonTapped(_ sender: StyledButton) {
        print("code recieved from user \(pincodeInputTextField.text!)")
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: self.code, verificationCode: pincodeInputTextField.text!)
        Auth.auth().signIn(with: credentials) { (result, err) in
            if let error = err {
                print(error)
            } else {
                self.defaults.set(true, forKey: "UserIsLoggedIn")
                let mainTabBar = MainTabBarController()
                mainTabBar.modalPresentationStyle = .fullScreen
                self.present(mainTabBar, animated: true, completion: nil)
//                self.navigationController?.pushViewController(mainVC, animated: true)
            }
        }

    }

    func setupLayout() {
        let constraints = [
            // Top lable layout
            descriptionTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 40),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            descriptionTextView.heightAnchor.constraint(equalToConstant: 24),

            // PinCode input layout

            pincodeInputTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            pincodeInputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pincodeInputTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            pincodeInputTextField.heightAnchor.constraint(equalToConstant: 100),

            // Continue button layout
            verificationButton.topAnchor.constraint(equalTo: pincodeInputTextField.bottomAnchor, constant: 10),
            verificationButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            verificationButton.heightAnchor.constraint(equalToConstant: 50),
            verificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)






        ]
        NSLayoutConstraint.activate(constraints)
    }
}
