//
//  BaseTableViewCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit
class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
