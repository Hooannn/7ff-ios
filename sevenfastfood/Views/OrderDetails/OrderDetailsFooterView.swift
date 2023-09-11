//
//  OrderDetailsFooterView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/09/2023.
//

import UIKit
protocol OrderDetailsFooterViewDelegate: AnyObject {
    func didTapRateButton(_ sender: UIButton)
}
final class OrderDetailsFooterView: BaseView {
    weak var delegate: OrderDetailsFooterViewDelegate?
    private lazy var contactButton: UIButton = {
        let button = Widgets.shared.createSecondaryButton(title: "Contact us", target: self, action: #selector(didTapContactButton(_:)))
        button.setImage(UIImage(systemName: "tray"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return button
    }()
    
    private lazy var rateButton: UIButton = {
        let button = Widgets.shared.createPrimaryButton(title: "Rate us", target: self, action: #selector(didTapRateButton(_:)))
        button.setImage(UIImage(systemName: "highlighter"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        button.isHidden = true
        return button
    }()
    
    func showRateButton() {
        rateButton.isHidden = false
        contactButton.isHidden = true
    }
    
    func showContactButton() {
        rateButton.isHidden = true
        contactButton.isHidden = false
    }
    
    override func setupViews() {
        backgroundColor = .white
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = Float(0.3)
        addSubviews(contactButton, rateButton)
    }
    
    override func setupConstraints() {
        [contactButton, rateButton].forEach {
            button in
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                button.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Tokens.shared.containerXPadding),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Tokens.shared.containerXPadding)
            ])
        }
    }
    
    @objc private func didTapContactButton(_ sender: UIButton) {
        if let url = NSURL(string:"mailto:sevenfastfoodservice@gmail.com") as? URL {
            UIApplication.shared.open(url) {
                done in
                if done {} else {
                    if let url = NSURL(string:"https://mail.google.com/mail/u/0/#inbox/FMfcgzGtwzrgNqxGJXldRLmCtrJrHNnH?compose=CllgCJZZzfCBczfFQjQLHwBtwFQRGzVxnXQcJhcXjmJklNZtdmNsxkgDBJlcBFrXBjHHWtxZjVB") as? URL {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    @objc private func didTapRateButton(_ sender: UIButton) {
        delegate?.didTapRateButton(sender)
    }
}
