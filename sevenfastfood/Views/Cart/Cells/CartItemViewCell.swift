//
//  CartItem.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

class CartItemViewCell: ClickableCollectionViewCell {
    var id: String?
    var name: String?
    {
        didSet {
            nameLabel.text = name
        }
    }
    
    var featuredImage: String?
    {
        didSet {
            featuredImageView.loadRemoteUrl(from: featuredImage)
        }
    }
    
    var category: String?
    {
        didSet {
            guard let category = category else { return }
            categoryLabel.text = category
        }
    }
    
    var unitPrice: Double?
    {
        didSet {
            guard let quantity = quantity, let unitPrice = unitPrice else { return }
            totalPrice = unitPrice * Double(quantity)
        }
    }
    
    var quantity: Int?
    {
        didSet {
            guard let quantity = quantity else { return }
            quantityInput.updateValue(quantity)
            guard let unitPrice = unitPrice else { return }
            totalPrice = unitPrice * Double(quantity)
        }
    }
    
    var totalPrice: Double?
    {
        didSet {
            guard let totalPrice = totalPrice else { return }
            totalPriceLabel.text = "\(totalPrice)đ"
        }
    }

    private lazy var featuredImageView: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        label.text = String(totalPrice ?? 0)
        return label
    }()

    private lazy var titleAndUnitPriceView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    private lazy var quantityInput: QuantityInputView = {
        let view = QuantityInputView()
        view.delegate = self
        return view
    }()
    
    private lazy var totalPriceAndQuantityView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceLabel, quantityInput])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .trailing
        return view
    }()

    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleAndUnitPriceView, totalPriceAndQuantityView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [featuredImageView, descriptionStackView])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        addSubviews(contentStackView)
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = CGColor(gray: 1, alpha: 1)
        layer.shadowOpacity = 0.3
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            featuredImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            featuredImageView.widthAnchor.constraint(equalTo: featuredImageView.heightAnchor),
            totalPriceAndQuantityView.heightAnchor.constraint(equalToConstant: 40),
            quantityInput.widthAnchor.constraint(equalTo: totalPriceAndQuantityView.widthAnchor, multiplier: 0.35),
            quantityInput.heightAnchor.constraint(equalTo: totalPriceAndQuantityView.heightAnchor, multiplier: 0.7),
            totalPriceLabel.heightAnchor.constraint(equalTo: totalPriceAndQuantityView.heightAnchor, multiplier: 0.7),
            
        ])
    }
}

extension CartItemViewCell: QuantityInputDelegate {
    func quantityInput(_ quantityInput: QuantityInputView, didChangeWithValue value: Int) {
        debugPrint("Receive new value -> \(value)")
    }
}
