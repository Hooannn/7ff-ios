//
//  OrdersHeaderView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit

final class OrdersHeaderView: BaseView {
    var itemsCount: Int = 0
    {
        didSet {
            itemsCountLabel.text = "\(itemsCount) orders"
        }
    }

    private lazy var magnifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Magnify")
        button.tintColor = Tokens.shared.secondaryColor
        button.addTarget(self, action: #selector(didTapSearchButton(_:)), for: .touchUpInside)
        button.setImage(iconImage, for: .normal)
        return button
    }()
    
    private lazy var greetingView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [itemsCountLabel, cartTitleLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private lazy var itemsCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(itemsCount) orders"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var cartTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Orders"
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
    }()
    
    override func setupViews() {
        addSubviews(greetingView, magnifyButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            magnifyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            magnifyButton.topAnchor.constraint(equalTo: topAnchor),
            magnifyButton.heightAnchor.constraint(equalTo: heightAnchor),
            magnifyButton.widthAnchor.constraint(equalTo: heightAnchor),
            
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            greetingView.trailingAnchor.constraint(equalTo: magnifyButton.leadingAnchor),
            greetingView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    @objc func didTapSearchButton(_ sender: UIButton) {
        debugPrint("Tap search in orders vc")
    }
}
