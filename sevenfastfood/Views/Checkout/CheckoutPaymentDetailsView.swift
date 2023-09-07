//
//  CheckoutPaymentDetailsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit

class CheckoutPaymentDetailsView: BaseView {
    var subtotal: Double?
    {
        didSet {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: (subtotal ?? 0) as NSNumber) {
                subtotalLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    var shippingFee: Double?
    {
        didSet {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: (shippingFee ?? 0) as NSNumber) {
                shippingFeeLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    var discount: Double?
    {
        didSet {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: (discount ?? 0) as NSNumber) {
                discountLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    var totalPrice: Double?
    {
        didSet {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: (totalPrice ?? 0) as NSNumber) {
                totalLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    
    private lazy var headerView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Payment Details"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        
        let view = UIStackView(arrangedSubviews: [titleLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var subtotalLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var shippingFeeLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var discountLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        label.textColor = .alizarin
        return label
    }()
    
    private lazy var contentView: UIStackView = {
        let subtotalTitleLabel = Widgets.shared.createLabel()
        subtotalTitleLabel.text = "Subtotal"
        let shippingFeeTitleLabel = Widgets.shared.createLabel()
        shippingFeeTitleLabel.text = "Shipping fee"
        let discountTitleLabel = Widgets.shared.createLabel()
        discountTitleLabel.text = "Discount"
        let totalTitleLabel = Widgets.shared.createLabel()
        totalTitleLabel.text = "Total"
        
        [subtotalTitleLabel, shippingFeeTitleLabel, discountTitleLabel].forEach {
            label in
            label.textColor = .systemGray
            label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        }
        totalTitleLabel.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        
        let subtotalView = UIStackView(arrangedSubviews: [subtotalTitleLabel, subtotalLabel])
        let shippingFeeView = UIStackView(arrangedSubviews: [shippingFeeTitleLabel, shippingFeeLabel])
        let discountView = UIStackView(arrangedSubviews: [discountTitleLabel, discountLabel])
        let totalView = UIStackView(arrangedSubviews: [totalTitleLabel, totalLabel])
        [subtotalView, shippingFeeView, discountView, totalView].forEach {
            view in
            view.axis = .horizontal
            view.alignment = .center
            view.distribution = .equalCentering
        }
        
        let stackView = UIStackView(arrangedSubviews: [subtotalView, shippingFeeView, discountView, totalView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func setupViews() {
        addSubviews(headerView, contentView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            headerView.heightAnchor.constraint(equalToConstant: 30),
            
            contentView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
}
