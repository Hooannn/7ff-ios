//
//  UpdateSingleFieldViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 03/09/2023.
//
import UIKit
import PhoneNumberKit

protocol UpdateSingleFieldViewControllerDelegate: AnyObject {
    func fieldDidSave(_ newValue: String, _ identifier: ProfileSectionItemIdentitier)
}

final class UpdateSingleFieldViewController: UIViewController {
    weak var delegate: UpdateSingleFieldViewControllerDelegate?
    private var identifier: ProfileSectionItemIdentitier?
    private var defaultValue: String = ""
    private var isEmpty: Bool = false
    private var needConfirmation: Bool = false
    
    convenience init(`for` identifier: ProfileSectionItemIdentitier, defaultValue: String, isEmpty: Bool, needConfirmation: Bool) {
        self.init(nibName: nil, bundle: nil)
        self.defaultValue = defaultValue
        self.isEmpty = isEmpty
        self.needConfirmation = needConfirmation
        self.identifier = identifier
    }
    
    private lazy var saveButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton(_:)))
        
        return item
    }()
    
    private lazy var phoneNumberTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: Tokens.shared.textFieldFontSize)
        textField.withFlag = false
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        if !isEmpty && identifier != .password {
            textField.text = try? textField.phoneNumberKit.parse("+\(defaultValue)").numberString
        }
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var updateTextField: UITextField = {
        let keyboardType: UIKeyboardType = identifier == .phoneNumber ? .phonePad : .default
        let textField = Widgets.shared.createTextField(placeholder: "Enter your \((title ?? "").lowercased())", delegate: self, keyboardType: keyboardType)
        if !isEmpty && identifier != .password {
            textField.text = defaultValue
        }
        if identifier == .password {
            textField.isSecureTextEntry = true
        }
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var confirmUpdateTextField: UITextField = {
        let textField = Widgets.shared.createTextField(placeholder: "Enter your \((title ?? "").lowercased()) again", delegate: self, keyboardType: .default)
        if identifier == .password {
            textField.isSecureTextEntry = true
        }
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        navigationItem.rightBarButtonItem = saveButton
        if identifier == .phoneNumber {
            addPhoneNumberTextField()
        } else {
            addGenericUpdateTextField()
        }
        
        if needConfirmation {
            addConfirmTextField()
        }
    }
    
    private func addGenericUpdateTextField() {
        view.addSubview(updateTextField)
        NSLayoutConstraint.activate([
            updateTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            updateTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            updateTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            updateTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
        ])
    }
    
    private func addPhoneNumberTextField() {
        view.addSubview(phoneNumberTextField)
        NSLayoutConstraint.activate([
            phoneNumberTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
        ])
    }
    
    private func addConfirmTextField() {
        view.addSubview(confirmUpdateTextField)
        NSLayoutConstraint.activate([
            confirmUpdateTextField.topAnchor.constraint(equalTo: identifier == .phoneNumber ? phoneNumberTextField.bottomAnchor : updateTextField.bottomAnchor),
            confirmUpdateTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            confirmUpdateTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            confirmUpdateTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
        ])
    }
    
    @objc private func didTapSaveButton(_ sender: UIBarButtonItem) {
        let rule = identifier == .password ? Utils.shared.minLengthOf6Rule(for: title ?? "") : Utils.shared.minLengthOf1Rule(for: title ?? "")
        if identifier != .phoneNumber {
            let validationResult = updateTextField.validate(rule: rule)
            switch validationResult {
            case .invalid(let error):
                Toast.shared.display(with: error.first?.message ?? "Something went wrong")
                return
            case .valid:
                break
            }
        } else {
            if !phoneNumberTextField.isValidNumber {
                Toast.shared.display(with: "Phone number must be valid")
                return
            }
        }
        
        if needConfirmation && (updateTextField.text != confirmUpdateTextField.text) {
            Toast.shared.display(with: "\(title ?? "")s do not match")
            return
        }
        
        guard let text = identifier != .phoneNumber ? updateTextField.text : "\(phoneNumberTextField.phoneNumber!.countryCode)\(phoneNumberTextField.phoneNumber!.nationalNumber)", let identifier = identifier else { return }
        delegate?.fieldDidSave(text, identifier)
    }
}

extension UpdateSingleFieldViewController: UITextFieldDelegate {
    
}
