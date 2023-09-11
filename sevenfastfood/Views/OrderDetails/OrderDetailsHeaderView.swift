//
//  OrderDetailsHeaderView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/09/2023.
//

import UIKit
final class OrderDetailsHeaderView: BaseView {
    private var orderStatus: OrderStatus?
    {
        didSet {
            guard let status = orderStatus else { return }
            let (image, title, background) = self.defineStatusTokens(for: status)
            imageView.image = image
            statusLabel.text = title
            backgroundColor = background.withAlphaComponent(0.3)
        }
    }
    
    private var orderId: String?
    {
        didSet {
            orderIdLabel.text = "Order #\(orderId ?? "")"
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var orderIdLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize, weight: .light)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let descView = UIStackView(arrangedSubviews: [orderIdLabel, statusLabel])
        descView.translatesAutoresizingMaskIntoConstraints = false
        descView.axis = .vertical
        
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.backgroundColor = .white
        imageContainerView.layer.cornerRadius = 12
        imageContainerView.addSubview(imageView)
        imageContainerView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor, constant: 4).isActive = true
        imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor, constant: 4).isActive = true
        imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor, constant: -4).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -4).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageContainerView, descView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    func setData(orderStatus: OrderStatus, orderId: String) {
        self.orderStatus = orderStatus
        self.orderId = orderId
    }
    
    private func defineStatusTokens(for status: OrderStatus) -> (UIImage?, String, UIColor) {
        switch status {
        case .All:
            return (UIImage(named: "Order_Processing"), "Being processed", Tokens.shared.primaryColor)
        case .Cancelled:
            return (UIImage(named: "Order_Cancelled"), "Cancelled", UIColor.alizarin)
        case .Delivering:
            return (UIImage(named: "Order_Delivery"), "On delilery", UIColor.systemBlue)
        case .Done:
            return (UIImage(named: "Order_Done"), "Done", UIColor.systemGreen)
        case .Processing:
            return (UIImage(named: "Order_Processing"), "Being processed", Tokens.shared.primaryColor)
        }
    }
    
    override func setupViews() {
        addSubview(stackView)
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }
}
