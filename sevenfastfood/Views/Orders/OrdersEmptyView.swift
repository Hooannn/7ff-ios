//
//  OrdersEmptyView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit

class OrdersEmptyView: BaseView {
    var title: String?
    {
        didSet {
            label.text = title ?? "Your orders is empty"
        }
    }
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "No_Data")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [imageView, label])
        view.axis = .vertical
        view.spacing = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25)
        ])
    }
}
