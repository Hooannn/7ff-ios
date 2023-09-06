//
//  SearchEmpty.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 04/09/2023.
//

import UIKit
class SearchEmptyView: BaseView {
    var searchString: String?
    {
        didSet {
            label.text = "We don't have any products related to '\(searchString ?? "")'"
        }
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: "Not_Found")
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
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        backgroundColor = .clear
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            
            imageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5)
        ])
    }
}
