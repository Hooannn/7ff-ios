//
//  SignUpFormView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/08/2023.
//

import UIKit
import Validator

enum TextFieldType: Int {
    case firstName = 1
    case lastName
    case email
    case password
}

struct SignUpForm {
    var lastName: String
    var firstName: String
    var email: String
    var password: String 
}

protocol SignUpFormViewDelegate: AnyObject {
    func didValidateFailed(messages _messages: [String])
    func didTapCreateAccountButton(form _form: SignUpForm)
    func didTapAlreadyHaveAccountButton()
}

final class SignUpFormView: UIView {
    weak var delegate: SignUpFormViewDelegate!
    weak var textFieldDelegate: UITextFieldDelegate!
    private let utils = Utils.shared
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
    }
    
    convenience init(textFieldDelegate _textFieldDelegate: UITextFieldDelegate) {
        self.init()
        self.textFieldDelegate = _textFieldDelegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        firstNameTextField = widgets.createTextField(placeholder: "Enter your first name...", delegate: self.textFieldDelegate!, keyboardType: .default)
        firstNameTextField.tag = TextFieldType.firstName.rawValue
        
        lastNameTextField = widgets.createTextField(placeholder: "Enter your last name...", delegate:  self.textFieldDelegate!, keyboardType: .default)
        lastNameTextField.tag = TextFieldType.lastName.rawValue
        
        emailTextField = widgets.createTextField(placeholder: "Enter your email...", delegate:  self.textFieldDelegate!, keyboardType: .emailAddress)
        emailTextField.tag = TextFieldType.email.rawValue

        passwordTextField = widgets.createTextField(placeholder: "Enter your password...", delegate:  self.textFieldDelegate!, keyboardType: .default)
        passwordTextField.tag = TextFieldType.password.rawValue
        passwordTextField.isSecureTextEntry = true

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
    
    private func validateTextFields() -> (Bool, [String]) {
        
        let emailValidationResult = emailTextField.validate(rule: utils.emailRule())
        let firstNameValidationResult = firstNameTextField.validate(rule: utils.minLengthOf1Rule(for: "First name"))
        let lastNameValidationResult = lastNameTextField.validate(rule: utils.minLengthOf1Rule(for: "Last name"))
        let passwordValidationResult = passwordTextField.validate(rule: utils.minLengthOf6Rule(for: "Password"))
        let results: [ValidationResult] = [emailValidationResult, firstNameValidationResult, lastNameValidationResult, passwordValidationResult]
        let errors = results.compactMap({
            result in
            switch result {
            case .invalid(let errors):
                return errors.first!.message
            default: return nil
            }
        })
        
        if errors.isEmpty {
            return (true, ["OK"])
        }
        
        return (false, errors)
    }
    
    @objc func didTapCreateButton() {
        
        let (isValid, messages) = validateTextFields()

        if !isValid {
            delegate.didValidateFailed(messages: messages)
            return
        }
        
        let form = SignUpForm(lastName: lastNameTextField.text!, firstName: firstNameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)

        delegate.didTapCreateAccountButton(form: form)
    }
    
    @objc func didTapAlreadyHaveAccountButton() {
        delegate.didTapAlreadyHaveAccountButton()
    }
}
