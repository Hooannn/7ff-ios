//
//  CheckoutVoucherView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit

enum VoucherState: String {
    case applying, empty
}

protocol CheckoutVoucherViewDelegate: AnyObject {
    func didTapApplyButton(_ sender: UIButton,_ voucherTextField: UITextField)
    func didTapCancelButton(_ sender: UIButton,_ voucherTextField: UITextField)
}

class CheckoutVoucherView: BaseView {
    weak var delegate: CheckoutVoucherViewDelegate?
    private lazy var textField: UITextField = {
        let textField = Widgets.shared.createTextField(placeholder: "Gift or discount code...", delegate: self, keyboardType: .default)
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.isEnabled = false
        button.tintColor = Tokens.shared.primaryColor
        button.addTarget(self, action: #selector(didTapApplyButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .alizarin
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        addSubviews(textField, applyButton, cancelButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
        ])
        
        [applyButton, cancelButton].forEach {
            button in
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 12),
                button.centerYAnchor.constraint(equalTo: centerYAnchor),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
            ])
        }
    }
    
    func setLoading(isLoading: Bool) {
        applyButton.setLoading(isLoading)
    }
    
    func setState(state: VoucherState) {
        switch state {
        case .applying:
            textField.isEnabled = false
            applyButton.isHidden = true
            cancelButton.isHidden = false
        case .empty:
            textField.isEnabled = true
            applyButton.isHidden = false
            cancelButton.isHidden = true
        }
    }
    
    @objc private func didTapApplyButton(_ sender: UIButton) {
        delegate?.didTapApplyButton(sender, textField)
    }
    
    @objc private func didTapCancelButton(_ sender: UIButton) {
        delegate?.didTapCancelButton(sender, textField)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if !textField.hasText {
            applyButton.isEnabled = false
        } else {
            applyButton.isEnabled = true
        }
    }
}

extension CheckoutVoucherView: UITextFieldDelegate {
    
}
