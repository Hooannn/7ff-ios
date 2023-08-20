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
    var productName: String?
    {
        didSet {
            productNameLabel.text = productName
        }
    }
    
    var productFeaturedImage: String?
    {
        didSet {
            productFeaturedImageView.loadRemoteUrl(from: productFeaturedImage)
        }
    }
    
    var productDescription: String?
    {
        didSet {
            productDescriptionLabel.text = productDescription
        }
    }
    
    var productPrice: String?
    {
        didSet {
            productPriceLabel.text = productPrice
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
    
    private lazy var productFeaturedImageView: UIImageView = {
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
    
    private lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = Tokens.shared.secondaryColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.textAlignment = .center
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Tokens.shared.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [productFeaturedImageView, productNameLabel, productDescriptionLabel, productPriceLabel])
        view.axis = .vertical
        view.spacing = 4
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isSkeletonable = true
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = CGColor(gray: 1, alpha: 1)
        layer.shadowOpacity = 0.3
        contentView.addSubviews(contentStackView, cartButton)
    }
    
    private func setupConstraints() {
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
