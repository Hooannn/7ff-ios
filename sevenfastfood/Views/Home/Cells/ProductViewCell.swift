//
//  ProductsCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 18/08/2023.
//

import Foundation
import UIKit
import SkeletonView

protocol ProductViewCellDelegate: AnyObject {
    func didTapOnProduct(withId productId: String?)
    func didEndLongPressOnProduct(withId productId: String?)
    func didTapCartButton(withId productId: String?)
}

final class ProductViewCell: ClickableCollectionViewCell {
    weak var delegate: ProductViewCellDelegate!
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
    
    var pdescription: String?
    {
        didSet {
            descriptionLabel.text = pdescription
        }
    }
    
    var price: Double?
    {
        didSet {
            priceLabel.text = "\(price!)đ"
        }
    }
    
    override func didEndLongPress() {
        delegate.didEndLongPressOnProduct(withId: id)
    }
    
    override func didTap(_ sender: UIGestureRecognizer) {
        super.didTap(sender)
        delegate.didTapOnProduct(withId: id)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private lazy var featuredImageView: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "Cart")
        button.addTarget(self, action: #selector(didTapCartButton), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = Tokens.shared.secondaryColor
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = Tokens.shared.secondaryColor
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Tokens.shared.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [featuredImageView, nameLabel, descriptionLabel, priceLabel])
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        isSkeletonable = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = CGColor(gray: 1, alpha: 1)
        layer.shadowOpacity = 0.3
        contentView.addSubviews(contentStackView, cartButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            cartButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            cartButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
    
    @objc func didTapCartButton() {
        delegate.didTapCartButton(withId: id)
    }
}
