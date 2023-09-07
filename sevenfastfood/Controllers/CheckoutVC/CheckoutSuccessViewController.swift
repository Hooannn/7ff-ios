//
//  CheckoutSuccessViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 07/09/2023.
//

import UIKit
final class CheckoutSuccessViewController: UIViewController {
    private var orderId: String?
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "Confirmed")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ordersButton: UIButton = {
        Widgets.shared.createTextButton(title: "See your orders", target: self, action: #selector(didTapOrdersButton(_:)))
    }()
    
    private lazy var homeButton: UIButton = {
        Widgets.shared.createPrimaryButton(title: "Home", target: self, action: #selector(didTapHomeButton(_:)))
    }()
    
    private lazy var contentStackView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Your order has been received"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        let orderIdLabel = Widgets.shared.createLabel()
        orderIdLabel.textColor = .systemGray
        orderIdLabel.text = "Order ID: \(orderId ?? "None")"
        
        
        let textView = UIStackView(arrangedSubviews: [titleLabel, orderIdLabel])
        textView.axis = .vertical
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.alignment = .leading
        textView.spacing = 2
        
        let actionView = UIStackView(arrangedSubviews: [homeButton, ordersButton])
        actionView.axis = .vertical
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.spacing = 2
        
        let stack = UIStackView(arrangedSubviews: [imageView, textView, actionView])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 36
        
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(contentStackView)
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        let backButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(didTapHomeButton(_:)))
        navigationItem.setLeftBarButton(backButton, animated: true)
        title = "Order confirmation"
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Tokens.shared.containerXPadding),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            homeButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            ordersButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
        ])
    }
    
    convenience init(orderId: String) {
        self.init(nibName: nil, bundle: nil)
        self.orderId = orderId
    }
    
    @objc private func didTapHomeButton(_ sender: UIButton) {
        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func didTapOrdersButton(_ sender: UIButton) {
        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
}
