//
//  SearchBarView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

final class SearchBarView: UIStackView {
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
        label.text = "Search something..."
        label.textColor = .systemGray2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        layer.cornerRadius = 12
        addArrangedSubview(magnifyButton)
        addArrangedSubview(searchTextLabel)
        addArrangedSubview(filterButton)
        axis = .horizontal
        alignment = .leading
        spacing = 12
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextLabel.heightAnchor.constraint(equalTo: heightAnchor),
            magnifyButton.heightAnchor.constraint(equalTo: heightAnchor),
            magnifyButton.widthAnchor.constraint(equalTo: heightAnchor, constant: 16),
            filterButton.heightAnchor.constraint(equalTo: heightAnchor),
            filterButton.widthAnchor.constraint(equalTo: heightAnchor, constant: 16)
        ])
    }
}
