//
//  FooterView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

class CartFooterView: BaseView {
    private lazy var checkoutButton: UIButton = {
        let button = Widgets.shared.createSecondaryButton(title: "Checkout", target: self, action: #selector(didTapCheckoutButton(_:)))
        button.setImage(UIImage(systemName: "exclamationmark.lock"), for: .normal)
        button.imageEdgeInsets.right = 8
        return button
    }()

    override func setupViews() {
        addSubviews(checkoutButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            checkoutButton.heightAnchor.constraint(equalToConstant: 54),
            checkoutButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkoutButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc func didTapCheckoutButton(_ sender: UIButton) {
        debugPrint("Tapped checkout")
    }
}
