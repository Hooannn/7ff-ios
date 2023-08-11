//
//  Widgets.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit


final class Widgets {
    public static let shared = Widgets()    
    private let tokens = Tokens.shared
    
    func createSecondaryButton(title _title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tokens.onSecondaryColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.backgroundColor = tokens.secondaryColor
        button.setTitle(_title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.shadowRadius = 4
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createPrimaryButton(title _title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tokens.onPrimaryColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.backgroundColor = tokens.primaryColor
        button.setTitle(_title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        button.layer.shadowRadius = 4
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createGoogleAuthButton(title _title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        let googleImage = UIImage(named: "Google")
        button.setImage(googleImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageEdgeInsets.left = -12
        button.tintColor = .darkText
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.setTitle(_title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createTextButton(title _title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.setTitle(_title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createTextField(placeholder _placeholder: String, delegate _delegate: UITextFieldDelegate, keyboardType _type: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.placeholder = _placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = _delegate
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: tokens.textFieldFontSize)
        textField.layer.cornerRadius = tokens.buttonCornerRadius
        textField.keyboardType = _type
        return textField
    }
}
