//
//  SignUpFormView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/08/2023.
//

import UIKit
import Validator

fileprivate enum TextFieldType: Int {
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
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, firstNameTextField, lastNameTextField, emailTextField, passwordTextField, submitButton, directToSignInButton])
        view.spacing = 12
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an account"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
    }()

    private lazy var firstNameTextField: UITextField = {
        let textField = widgets.createTextField(placeholder: "Enter your first name...", delegate: self.textFieldDelegate!, keyboardType: .default)
        textField.tag = TextFieldType.firstName.rawValue
        return textField
    }()

    private lazy var lastNameTextField: UITextField = {
        let textField = widgets.createTextField(placeholder: "Enter your last name...", delegate:  self.textFieldDelegate!, keyboardType: .default)
        textField.tag = TextFieldType.lastName.rawValue
        return textField
    }()

    private lazy var emailTextField: UITextField = {
        let textField = widgets.createTextField(placeholder: "Enter your email...", delegate:  self.textFieldDelegate!, keyboardType: .emailAddress)
        textField.tag = TextFieldType.email.rawValue
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = widgets.createTextField(placeholder: "Enter your password...", delegate:  self.textFieldDelegate!, keyboardType: .default)
        textField.tag = TextFieldType.password.rawValue
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var submitButton: UIButton = {
        widgets.createPrimaryButton(title: "Create an Account", target: self, action: #selector(didTapCreateButton))
    }()

    private lazy var directToSignInButton: UIButton = {
        widgets.createTextButton(title: "Already have an account?", target: self, action: #selector(didTapAlreadyHaveAccountButton))
    }()
    
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
    
    func setLoading(_ isLoading: Bool) {
        submitButton.setLoading(isLoading)
    }

    private func setupViews() {
        addSubviews(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstNameTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            lastNameTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            emailTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            passwordTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            submitButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            directToSignInButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight)
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
