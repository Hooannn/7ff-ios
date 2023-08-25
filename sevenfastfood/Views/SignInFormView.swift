//
//  SignUpFormView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/08/2023.
//

import UIKit
import Validator

fileprivate enum TextFieldType: Int {
    case email = 1
    case password
}

struct SignInForm {
    var email: String
    var password: String
}

protocol SignInFormViewDelegate: AnyObject {
    func didValidateFailed(messages _messages: [String])
    func didTapSignInButton(form _form: SignInForm)
    func didTapDoNotHaveAnAccountYetButton()
}

final class SignInFormView: UIView {
    weak var delegate: SignInFormViewDelegate!
    weak var textFieldDelegate: UITextFieldDelegate!
    private let utils = Utils.shared
    private let widgets = Widgets.shared
    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, emailTextField, passwordTextField, submitButton, directToSignUpButton])
        view.spacing = 12
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign In"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
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
        widgets.createPrimaryButton(title: "Sign in", target: self, action: #selector(didTapSubmitButton))
    }()
    
    private lazy var directToSignUpButton: UIButton = {
        widgets.createTextButton(title: "Don't have an account yet?", target: self, action: #selector(didTapDoNotHaveAnAccountYetButton))
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
            emailTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            passwordTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            submitButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4),
            directToSignUpButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight - 4)
        ])
    }
    
    private func validateTextFields() -> (Bool, [String]) {
        
        let emailValidationResult = emailTextField.validate(rule: utils.emailRule())
        let passwordValidationResult = passwordTextField.validate(rule: utils.minLengthOf6Rule(for: "Password"))
        let results: [ValidationResult] = [emailValidationResult, passwordValidationResult]
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
    
    @objc func didTapSubmitButton() {
        
        let (isValid, messages) = validateTextFields()

        if !isValid {
            delegate.didValidateFailed(messages: messages)
            return
        }
        
        let form = SignInForm(email: emailTextField.text!, password: passwordTextField.text!)

        delegate.didTapSignInButton(form: form)
    }
    
    @objc func didTapDoNotHaveAnAccountYetButton() {
        delegate.didTapDoNotHaveAnAccountYetButton()
    }
}
