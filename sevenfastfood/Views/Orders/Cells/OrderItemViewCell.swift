//
//  OrderItemViewCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit

final class OrderItemViewCell: BaseCollectionViewCell {
    var featuredImage: String?{
        didSet {
            featuredImageView.loadRemoteUrl(from: featuredImage)
        }
    }
    
    var title: String?
    var totalPrice: Double?
    var unitPrice: Double?
    var quantity: Int?
    {
        didSet {
            if let title = title {
                nameLabel.text = "\(title) x \(quantity ?? 0)"
            }
            if let unitPrice = unitPrice {
                let formatter = NumberFormatter()
                formatter.locale = Locale.init(identifier: "vi_VN")
                formatter.numberStyle = .currency
                let totalPrice = Double(quantity ?? 0) * (unitPrice)
                if let formattedTotalPrice = formatter.string(from: totalPrice as NSNumber) {
                    totalPriceLabel.text = "\(formattedTotalPrice)"
                }
            }
        }
    }
    
    private lazy var featuredImageView: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, totalPriceLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.distribution = .equalSpacing
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
        contentView.addSubviews(contentStackView)
        backgroundColor = .clear
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            descriptionStackView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            
            featuredImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            featuredImageView.widthAnchor.constraint(equalTo: featuredImageView.heightAnchor)
        ])
    }
}
