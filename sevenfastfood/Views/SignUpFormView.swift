//
//  SignUpFormView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/08/2023.
//

import UIKit


final class SignUpFormView: UIView {
    private let widgets = Widgets.shared
    private var stackView: UIStackView!
    private var firstNameTextField: UITextField!
    private var lastNameTextField: UITextField!
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var submitButton: UIButton!
    private var directToSignInButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        firstNameTextField = widgets.createTextField(placeholder: "Enter your first name...", delegate: self, keyboardType: .default)
        
        lastNameTextField = widgets.createTextField(placeholder: "Enter your last name...", delegate: self, keyboardType: .default)
        
        emailTextField = widgets.createTextField(placeholder: "Enter your email...", delegate: self, keyboardType: .emailAddress)
        
        passwordTextField = widgets.createTextField(placeholder: "Enter your password...", delegate: self, keyboardType: .default)
        
        submitButton = widgets.createPrimaryButton(title: "Create an Account", target: self, action: #selector(didTapCreateButton))
        
        directToSignInButton = widgets.createTextButton(title: "Already have an account?", target: self, action: #selector(didTapAlreadyHaveAccountButton))
        stackView = {
            let view = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, emailTextField, passwordTextField,  submitButton,directToSignInButton])
            view.spacing = 12
            view.axis = .vertical
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        addSubviews(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 44),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 44),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func didTapCreateButton() {
        
    }
    
    @objc func didTapAlreadyHaveAccountButton() {
        
    }
}


extension SignUpFormView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text)
    }
}
