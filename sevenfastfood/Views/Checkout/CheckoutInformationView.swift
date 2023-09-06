//
//  OrderInformationView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit

class CheckoutInformationView: BaseView {
    var name: String?
    {
        didSet {
            nameLabel.text = name
        }
    }
    
    var address: String?
    {
        didSet {
            addressLabel.text = address
        }
    }
    
    var phoneNumber: String?
    {
        didSet {
            phoneLabel.text = phoneNumber
        }
    }
    
    private lazy var headerView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Order Information"
        titleLabel.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.tintColor = Tokens.shared.primaryColor
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let view = UIStackView(arrangedSubviews: [titleLabel, editButton])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalCentering
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Your name"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Your address"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var phoneLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Your phone"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var contentView: UIStackView = {
        let nameTitleLabel = Widgets.shared.createLabel()
        nameTitleLabel.text = "Name"
        let addressTitleLabel = Widgets.shared.createLabel()
        addressTitleLabel.text = "Address"
        let phoneTitleLabel = Widgets.shared.createLabel()
        phoneTitleLabel.text = "Phone"
        
        [nameTitleLabel, addressTitleLabel, phoneTitleLabel].forEach {
            label in
            label.textColor = .systemGray
            label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        }
        
        let nameView = UIStackView(arrangedSubviews: [nameTitleLabel, nameLabel])
        let addressView = UIStackView(arrangedSubviews: [addressTitleLabel, addressLabel])
        let phoneView = UIStackView(arrangedSubviews: [phoneTitleLabel, phoneLabel])
        
        [nameView, addressView, phoneView].forEach {
            view in
            view.axis = .horizontal
            view.alignment = .center
            view.distribution = .equalCentering
        }
        
        let stackView = UIStackView(arrangedSubviews: [nameView, addressView, phoneView])
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
