//
//  FooterView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

class CartFooterView: BaseView {
    var totalPrice: Double = 20000
    private lazy var checkoutButton: UIButton = {
        let button = Widgets.shared.createSecondaryButton(title: "Checkout", target: self, action: #selector(didTapCheckoutButton(_:)))
        button.setImage(UIImage(systemName: "exclamationmark.lock"), for: .normal)
        button.imageEdgeInsets.right = 8
        return button
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        label.textColor = .alizarin
        label.text = "\(totalPrice)đ"
        return label
    }()

    private lazy var totalPriceView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Total"
        let view = UIStackView(arrangedSubviews: [titleLabel, totalPriceLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceView, checkoutButton])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        return view
    }()

    override func setupViews() {
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            checkoutButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    @objc func didTapCheckoutButton(_ sender: UIButton) {
        debugPrint("Tapped checkout")
    }
}
