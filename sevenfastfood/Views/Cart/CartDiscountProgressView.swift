//
//  CartDiscountProgressView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 01/09/2023.
//

import UIKit
class CartDiscountProgressView: BaseView {
    private static let MINIMUM_VALUE_FOR_FREE_SHIPPING: Double = 300000
    var totalPrice: Double = 0
    {
        didSet {
            let isEnough = totalPrice >= CartDiscountProgressView.MINIMUM_VALUE_FOR_FREE_SHIPPING
            if isEnough {
                textLabel.text = "Your order is free shipping now"
            } else {
                let additionalPrice = CartDiscountProgressView.MINIMUM_VALUE_FOR_FREE_SHIPPING - totalPrice
                let formatter = NumberFormatter()
                formatter.locale = Locale.init(identifier: "vi_VN")
                formatter.numberStyle = .currency
                if let formattedAdditionalPrice = formatter.string(from: additionalPrice as NSNumber) {
                    textLabel.text = "Buy \(formattedAdditionalPrice) more to get free shipping"
                }
            }
            textLabel.sizeToFit()
            animateProgressBar()
        }
    }
    
    private lazy var textLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize, weight: .light)
        return label
    }()
    
    private lazy var progressBarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var progressBarInnerView: UIView = {
        let view = UIView()
        view.backgroundColor = Tokens.shared.secondaryColor
        view.layer.cornerRadius = 3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [textLabel, progressBarContainerView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    private func animateProgressBar() {
        let progress = totalPrice / CartDiscountProgressView.MINIMUM_VALUE_FOR_FREE_SHIPPING >= 1 ? 1 : totalPrice / CartDiscountProgressView.MINIMUM_VALUE_FOR_FREE_SHIPPING
        let progressBarInnerConstraint = totalPrice > 0 ? progressBarInnerView.widthAnchor.constraint(equalTo: progressBarContainerView.widthAnchor, multiplier: progress) : progressBarInnerView.widthAnchor.constraint(equalToConstant: 0)

        let constraints: [NSLayoutConstraint] = [progressBarInnerConstraint]
        
        UIView.animate(withDuration: 0.3, animations: {
            NSLayoutConstraint.activate(constraints)
            self.layoutIfNeeded()
        })
    }
    
    override func setupViews() {
        backgroundColor = .clear
        progressBarContainerView.addSubview(progressBarInnerView)
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            progressBarContainerView.widthAnchor.constraint(equalTo: widthAnchor),
            progressBarContainerView.heightAnchor.constraint(equalToConstant: 6),
            
            progressBarInnerView.heightAnchor.constraint(equalTo: progressBarContainerView.heightAnchor),
            progressBarInnerView.leadingAnchor.constraint(equalTo: progressBarContainerView.leadingAnchor)
        ])
        layoutIfNeeded()
    }
}
