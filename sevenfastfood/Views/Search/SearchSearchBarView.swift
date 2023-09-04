//
//  SearchBar.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 04/09/2023.
//

import UIKit
protocol SearchSearchBarViewDelegate: AnyObject {
    func didTapCloseButton(_ sender: UIButton)
    func searchTextFieldDidChange(_ sender: UITextField)
}

final class SearchSearchBarView: UIView, UITextFieldDelegate {
    private var widgets = Widgets.shared
    weak var delegate: SearchSearchBarViewDelegate?
    private lazy var magnifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Magnify")
        button.setImage(iconImage, for: .normal)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = widgets.createTextField(placeholder: "Search...", delegate: self, keyboardType: .default)
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(searchTextFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [magnifyButton, searchTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        return stackView
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Tokens.shared.primaryColor
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(delegate: SearchSearchBarViewDelegate) {
        self.init(frame: .zero)
        self.delegate = delegate
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        addSubviews(contentStackView, closeButton)
        
        searchTextField.becomeFirstResponder()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            closeButton.heightAnchor.constraint(equalTo: heightAnchor),
            closeButton.widthAnchor.constraint(equalTo: closeButton.heightAnchor),
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -12),
            
            searchTextField.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            magnifyButton.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            magnifyButton.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 8)
        ])
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        delegate?.didTapCloseButton(sender)
    }
    
    @objc private func searchTextFieldDidChange(_ sender: UITextField) {
        delegate?.searchTextFieldDidChange(sender)
    }
}
