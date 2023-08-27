//
//  QuantityInputView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 27/08/2023.
//

import UIKit

protocol QuantityInputDelegate: AnyObject {
    func quantityInput(_ quantityInput: QuantityInputView, didChangeWithValue value: Int)
}

class QuantityInputView: BaseView {
    weak var delegate: QuantityInputDelegate?
    private var quantity: Int?
    {
        didSet {
            textField.text = String(quantity ?? 1)
        }
    }
    
    private lazy var increaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapIncButton(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.tintColor = Tokens.shared.primaryColor
        return button
    }()
    
    private lazy var decreaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapDecButton(_:)), for: .touchUpInside)
        button.setImage(UIImage(named: "Minus"), for: .normal)
        button.tintColor = Tokens.shared.primaryColor
        return button
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.autocapitalizationType = .none
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: UIFont.systemFontSize, weight: .light)
        return textField
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [decreaseButton, textField, increaseButton])
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .equalSpacing
        return view
    }()
    
    convenience init(defaultValue: Int) {
        self.init(frame: .zero)
    }
    
    func updateValue(_ newValue: Int) {
        self.quantity = newValue
    }

    override func setupViews() {
        addSubview(containerStackView)
        clipsToBounds = true
        layer.cornerRadius = 4
        backgroundColor = Tokens.shared.primaryBackgroundColor
        layer.borderWidth = 1
        layer.borderColor = Tokens.shared.primaryColor.cgColor
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            textField.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.32)
        ])
    }
    
    @objc func didTapIncButton(_ sender: UIButton) {
        let current = Int(textField.text ?? "1") ?? 1
        let newValue = current + 1
        textField.text = String(newValue)
        notifyChange()
    }
    
    @objc func didTapDecButton(_ sender: UIButton) {
        let current = Int(textField.text ?? "1") ?? 1
        var newValue = current - 1
        if newValue <= 0 {
            newValue = 0
        }
        textField.text = String(newValue)
        notifyChange()
    }
    
    private func notifyChange() {
        let intValue = Int(textField.text ?? "1") ?? 1
        delegate?.quantityInput(self, didChangeWithValue: intValue)
    }
}

extension QuantityInputView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let text = textField.text, text != "" {} else {
            textField.text = "1"
        }
        notifyChange()
    }
}
