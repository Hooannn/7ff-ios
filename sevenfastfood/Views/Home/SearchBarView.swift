//
//  SearchBarView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit
protocol SearchBarViewDelegate: AnyObject {
    func didTapSearchBar(_ sender: UIGestureRecognizer)
}
final class SearchBarView: ClickableView {
    weak var delegate: SearchBarViewDelegate!
    private var widgets = Widgets.shared
    private lazy var magnifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Magnify")
        button.setImage(iconImage, for: .normal)
        return button
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Filter")
        button.setImage(iconImage, for: .normal)
        button.tintColor = .systemGray2
        return button
    }()
    
    private lazy var searchTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search..."
        label.textColor = .systemGray2
        return label
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [magnifyButton, searchTextLabel, filterButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 12
        return stackView
    }()
    
    override func didTap(_ sender: UIGestureRecognizer) {
        super.didTap(sender)
        delegate.didTapSearchBar(sender)
    }
    
    override func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        clipsToBounds = true
        addSubview(contentStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchTextLabel.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            magnifyButton.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            magnifyButton.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 16),
            filterButton.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            filterButton.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 16)
        ])
    }
}
