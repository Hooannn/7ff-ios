//
//  SearchItemViewCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 05/09/2023.
//

import UIKit

protocol SearchItemCellDelegate: AnyObject {
    
}

class SearchItemViewCell: ClickableCollectionViewCell {
    weak var delegate: SearchItemCellDelegate?
    var productId: String?
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
            guard let unitPrice = unitPrice else { return }
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: unitPrice as NSNumber) {
                unitPriceLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    
    var viewThisMonth: Int?
    {
        didSet {
            viewThisMonthLabel.text = "View this month: \(viewThisMonth ?? 0)"
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
    
    private lazy var titleAndCategoryView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    private lazy var unitPriceLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var viewThisMonthLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var unitPriceAndViewThisMonthView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [unitPriceLabel, viewThisMonthLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .trailing
        return view
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleAndCategoryView, unitPriceAndViewThisMonthView])
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
        contentView.addSubviews(contentStackView)
        backgroundColor = .white
        clipsToBounds = false
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
            unitPriceAndViewThisMonthView.heightAnchor.constraint(equalToConstant: 40),
            viewThisMonthLabel.widthAnchor.constraint(equalTo: unitPriceAndViewThisMonthView.widthAnchor, multiplier: 0.35),
            viewThisMonthLabel.heightAnchor.constraint(equalTo: unitPriceAndViewThisMonthView.heightAnchor, multiplier: 0.7),
            unitPriceLabel.heightAnchor.constraint(equalTo: unitPriceAndViewThisMonthView.heightAnchor, multiplier: 0.7)
        ])
    }
}
