//
//  CategoriesView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

final class CategoriesView: UIScrollView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
    }
}
