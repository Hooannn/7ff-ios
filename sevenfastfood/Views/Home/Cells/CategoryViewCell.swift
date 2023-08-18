//
//  CategoryCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 18/08/2023.
//

import Foundation
import UIKit

final class CategoryViewCell: UICollectionViewCell {
    override var isSelected: Bool
    {
        didSet(newValue) {
            label.textColor = newValue ? .black : .systemGray2
            dotView.isHidden = newValue ? false : true
        }
    }
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private let dotView: UIView = {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.layer.cornerRadius = 4
        dot.backgroundColor = .black
        dot.isHidden = true
        return dot
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(label, dotView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
    }

    private func setupConstraints() {
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

