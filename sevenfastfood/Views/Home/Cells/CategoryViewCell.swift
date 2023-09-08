//
//  CategoryCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 18/08/2023.
//

import Foundation
import UIKit

final class CategoryViewCell: BaseCollectionViewCell {
    override var isSelected: Bool
    {
        didSet {
            label.textColor = isSelected ? .black : .systemGray2
            dotView.isHidden = isSelected ? false : true
        }
    }
    
    let label: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private let dotView: BaseView = {
        let dot = BaseView()
        dot.layer.cornerRadius = 4
        dot.backgroundColor = .black
        dot.isHidden = true
        return dot
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }
    
    override func setupViews() {
        isSkeletonable = true
        clipsToBounds = false
        contentView.addSubviews(label, dotView)
    }

    override func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            dotView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dotView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            dotView.widthAnchor.constraint(equalTo: dotView.heightAnchor),
            dotView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
        ])
    }
}

