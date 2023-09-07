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
    
    func createSecondaryButton(title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tokens.onSecondaryColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.backgroundColor = tokens.secondaryColor
        button.setTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createPrimaryButton(title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = tokens.onPrimaryColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.backgroundColor = tokens.primaryColor
        button.setTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createDangerButton(outline: Bool, title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = outline ? .alizarin : .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.backgroundColor = outline ? .clear : .alizarin
        button.setTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        if outline {
            button.layer.borderColor = UIColor.alizarin.cgColor
            button.layer.borderWidth = 1
        }
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    public func createGoogleAuthButton(title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
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
        button.setTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.layer.cornerRadius = tokens.buttonCornerRadius
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createTextButton(title: String, target: Any?, action: Selector, `for`: UIButton.Event? = .touchUpInside) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemGray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        button.setTitle(title, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        button.addTarget(target, action: action, for: `for`!)
        return button
    }
    
    func createTextField(placeholder: String, delegate: UITextFieldDelegate, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = delegate
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: tokens.textFieldFontSize)
        textField.layer.cornerRadius = tokens.buttonCornerRadius
        textField.keyboardType = keyboardType
        
        return textField
    }
    
    func createTextView(placeholder: String, delegate: UITextViewDelegate, keyboardType: UIKeyboardType) -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = delegate
        textView.autocapitalizationType = .none
        textView.font = UIFont.systemFont(ofSize: tokens.textFieldFontSize)
        textView.layer.cornerRadius = 4
        textView.keyboardType = keyboardType
        
        return textView
    }
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Tokens.shared.secondaryColor
        return label
    }
}
