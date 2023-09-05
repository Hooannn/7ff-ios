//
//  CartEmptyStateView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 01/09/2023.
//

import UIKit
class CartEmptyView: BaseView {
    var didTapShoppingButton: (() -> Void)?
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "Empty_Cart_2")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Your cart is empty"
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var shoppingButton: UIButton = {
        let button = Widgets.shared.createPrimaryButton(title: "Shopping", target: self, action: #selector(didTapShoppingButton(_:)))
        
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, label, shoppingButton])
        view.axis = .vertical
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func didTapShoppingButton(_ sender: UIButton) {
        self.didTapShoppingButton?()
    }
    
    override func setupViews() {
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25),
            shoppingButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight)
        ])
    }
}
