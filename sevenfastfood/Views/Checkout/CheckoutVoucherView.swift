//
//  CheckoutVoucherView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit

class CheckoutVoucherView: BaseView {
    private lazy var textField: UITextField = {
        let textField = Widgets.shared.createTextField(placeholder: "Gift or discount code...", delegate: self, keyboardType: .default)
        textField.borderStyle = .none
        return textField
    }()
    
    private lazy var applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apply", for: .normal)
        button.tintColor = Tokens.shared.primaryColor
        button.addTarget(self, action: #selector(didTapApplyButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override func setupViews() {
        addSubviews(textField, applyButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            applyButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 12),
            applyButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            applyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
        ])
    }
    
    @objc private func didTapApplyButton(_ sender: UIButton) {
        
    }
}

extension CheckoutVoucherView: UITextFieldDelegate {
    
}
