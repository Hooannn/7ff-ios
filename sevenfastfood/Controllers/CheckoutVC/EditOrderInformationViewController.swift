//
//  EditOrderInformationViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 07/09/2023.
//

import UIKit
import PhoneNumberKit

protocol EditOrderInformationViewControllerDelegate: AnyObject {
    func didSave(_ sender: UIBarButtonItem,_ address: String,_ phone: String)
}

final class EditOrderInformationViewController: UIViewController {
    weak var delegate: EditOrderInformationViewControllerDelegate?
    private lazy var addressTextView: UITextView = {
        let textView = Widgets.shared.createTextView(placeholder: "Enter your address", delegate: self, keyboardType: .default)
        return textView
    }()
    
    private lazy var phoneNumberTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: Tokens.shared.textFieldFontSize)
        textField.withFlag = false
        textField.withPrefix = true
        textField.withExamplePlaceholder = true
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let addressLabel = Widgets.shared.createLabel()
        let phoneLabel = Widgets.shared.createLabel()
        addressLabel.text = "Address"
        phoneLabel.text = "Phone"
        
        [addressLabel, phoneLabel].forEach {
            label in
            label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        }
        
        let addressSection = UIStackView(arrangedSubviews: [addressLabel, addressTextView])
        let phoneSection = UIStackView(arrangedSubviews: [phoneLabel, phoneNumberTextField])
        [addressSection, phoneSection].forEach {
            stack in
            stack.axis = .vertical
            stack.spacing = 2
            stack.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let stack = UIStackView(arrangedSubviews: [addressSection, phoneSection])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    convenience init(address: String? = nil, phone: String? = nil) {
        self.init(nibName: nil, bundle: nil)
        self.addressTextView.text = address
        if let phone = phone {
            self.phoneNumberTextField.text = try? self.phoneNumberTextField.phoneNumberKit.parse("+\(phone)").numberString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        navigationController?.navigationBar.tintColor = Tokens.shared.primaryColor
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        title = "Order Information"
        let leftBarButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(didTapCloseButton(_:)))
        let rightBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSaveButton(_:)))
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = leftBarButton
        view.addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            addressTextView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight * 3),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
        ])
    }
    
    @objc private func didTapCloseButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton(_ sender: UIBarButtonItem) {
        let addressRule = Utils.shared.minLengthOf1Rule(for: "Address")
        if !phoneNumberTextField.isValidNumber {
            Toast.shared.display(with: "Phone number must be valid")
            return
        }
        let addressValidationResult = addressTextView.validate(rule: addressRule)
        switch addressValidationResult {
        case .invalid(let error):
            Toast.shared.display(with: error.first?.message ?? "Something went wrong")
            return
        case .valid:
            break
        }
        
        guard let address = addressTextView.text else { return }
        let phone = "\(phoneNumberTextField.phoneNumber!.countryCode)\(phoneNumberTextField.phoneNumber!.nationalNumber)"
        dismiss(animated: true) {
            self.delegate?.didSave(sender, address, phone)
        }
    }
}

extension EditOrderInformationViewController: UITextFieldDelegate, UITextViewDelegate {}
