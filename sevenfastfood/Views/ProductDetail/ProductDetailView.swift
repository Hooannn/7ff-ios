//
//  ProductDetailView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import UIKit


class ProductDetailView: UIView {
    private lazy var product: Product? = nil
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var topConstant: CGFloat!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var productTitleView: UIStackView = {
        let categoryLabel = UILabel()
        categoryLabel.text = product?.category?.name.en
        categoryLabel.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        categoryLabel.textColor = Tokens.shared.secondaryColor
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.text = product?.name.en
        titleLabel.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        titleLabel.textColor = Tokens.shared.secondaryColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [productTitleView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(product: Product?, topConstant: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.topConstant = topConstant
        self.product = product
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        scrollView.addSubviews(contentStackView)
        addSubviews(footerView, scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 120),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        ])
    }
}
