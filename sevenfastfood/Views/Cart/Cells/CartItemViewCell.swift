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
    
    var unitPrice: Double?
    {
        didSet {
            unitPriceLabel.text = "Unit price: \(unitPrice ?? 0)đ"
        }
    }
    
    var quantity: Int?
    {
        didSet {
            quantityLabel.text = "Quantity: \(quantity ?? 0)"
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
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Tokens.shared.secondaryColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var unitPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Tokens.shared.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, unitPriceLabel, quantityLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
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
    
    private lazy var quantityCounterView: UIView = {
        let v = UIView()
        return v
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
            
            featuredImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            featuredImageView.widthAnchor.constraint(equalTo: featuredImageView.heightAnchor)
        ])
    }
}
