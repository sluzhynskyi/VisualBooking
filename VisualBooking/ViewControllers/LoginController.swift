//
//  Login.swift
//  VisualBooking
//
//  Created by Danylo Sluzhynskyi on 17.12.2020.
//

import Foundation
import UIKit
import FlagPhoneNumber
import Firebase

class LoginController: UIViewController, FPNTextFieldDelegate {
    var phoneNumber: String = ""
    var code: String = ""
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)


    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
    }

    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            phoneNumberTextField.resignFirstResponder()
            phoneNumber = textField.getFormattedPhoneNumber(format: .E164)! // Output "+33600000001"
        } else {
            // Do something...
            print("Not valid")
        }
    }

    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        present(navigationViewController, animated: true, completion: nil)

    }

    @UsesAutoLayout
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    @UsesAutoLayout
    var welcomeLable: UILabel = {
        let label = UILabel()
        label.text = "Enter your number"
        label.textColor = .black
        label.backgroundColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()

    @UsesAutoLayout
    var phoneNumberTextField: FPNTextField = {
        let textField = FPNTextField()
        textField.textColor = .black
        textField.displayMode = .list
        textField.font = .boldSystemFont(ofSize: 18)
        textField.backgroundColor = UIColor(hex: "#f4f4f6ff")!

        return textField
    }()

    @UsesAutoLayout
    var loginButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.setTitle("CONTINUE", for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return button
    }()




    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        phoneNumberTextField.delegate = self

        loginButton.titleLabel!.font = .boldSystemFont(ofSize: 18)

        [welcomeLable, phoneNumberTextField, loginButton].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(stackView)
        [loginButton].forEach { $0.addShadow(); $0.addCorners() }
        setupLayout()
        listController.setup(repository: phoneNumberTextField.countryRepository)
        listController.didSelect = { [weak self] country in
            self?.phoneNumberTextField.setFlag(countryCode: country.code) }




    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }


    @objc func loginButtonTapped(_ sender: StyledButton) {
        let pincodeTest = PincodeTestController()
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        print("phone number \(phoneNumber)")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (CODE, err) in
            if let error = err {
                print("Error while getiing code")
                print(error.localizedDescription)
                return
            } else {
                print("without error, code is: \(CODE!)")
                pincodeTest.code = CODE! }
        }

        pincodeTest.phoneNumber = self.phoneNumber
        print("code recieved from fb \(self.code)")
        navigationController?.pushViewController(pincodeTest, animated: true)


    }

    func setupLayout() {
        let constraints = [
            // Stackview layout
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // Phone number input layout
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),
            phoneNumberTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

            // Login button layout
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 50),


        ]
        NSLayoutConstraint.activate(constraints)
    }
}
