//
//  BaseCollectionViewCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 01/09/2023.
//

import UIKit
class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupViews() {
        
    }
    
    internal func setupConstraints() {
        
    }
}

