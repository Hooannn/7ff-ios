//
//  CheckoutFooterView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit
protocol CheckoutFooterDelegate: AnyObject {
    func didTapSubmitButton(_ sender: UIButton)
}

class CheckoutFooterView: BaseView {
    weak var delegate: CheckoutFooterDelegate?
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
    
    private lazy var totalLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        label.textColor = .alizarin
        return label
    }()
    
    private lazy var totalView: UIStackView = {
        let totalTitleLabel = Widgets.shared.createLabel()
        totalTitleLabel.text = "Total"
        let stack = UIStackView(arrangedSubviews: [totalTitleLabel, totalLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var submitButton: UIButton = {
        let primaryButton = Widgets.shared.createSecondaryButton(title: "Place order", target: self, action: #selector(didTapSubmitButton(_:)))
        return primaryButton
    }()
    
    override func setupViews() {
        addSubviews(totalView, submitButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            totalView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            totalView.heightAnchor.constraint(equalToConstant: 24),
            totalView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Tokens.shared.containerXPadding),
            totalView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Tokens.shared.containerXPadding),
            
            submitButton.topAnchor.constraint(equalTo: totalView.bottomAnchor, constant: 8),
            submitButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Tokens.shared.containerXPadding),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Tokens.shared.containerXPadding)
        ])
    }
    
    @objc private func didTapSubmitButton(_ sender: UIButton) {
        delegate?.didTapSubmitButton(sender)
    }
}
