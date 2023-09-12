//
//  SearchBarView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit
protocol SearchBarViewDelegate: AnyObject {
    func didTapSearchBar(_ sender: UIGestureRecognizer)
    func didTapSortButton(_ sender: UIButton)
}
final class SearchBarView: ClickableView {
    weak var delegate: SearchBarViewDelegate?
    private var widgets = Widgets.shared
    private lazy var magnifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Magnify")
        button.setImage(iconImage, for: .normal)
        return button
    }()
    
    private lazy var sortButtonBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let iconImage = UIImage(named: "Filter")
        button.setImage(iconImage, for: .normal)
        button.tintColor = .systemGray2
        button.addTarget(self, action: #selector(didTapSortButton(_:)), for: .touchUpInside)
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
        let stackView = UIStackView(arrangedSubviews: [magnifyButton, searchTextLabel, sortButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 12
        return stackView
    }()
    
    func showSortButtonBadge() {
        sortButtonBadge.isHidden = false
    }
    
    func hideSortButtonBadge() {
        sortButtonBadge.isHidden = true
    }
    
    override func didTap(_ sender: UITapGestureRecognizer) {
        super.didTap(sender)
        delegate?.didTapSearchBar(sender)
    }
    
    override func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
        addSubviews(contentStackView, sortButtonBadge)
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
            sortButton.heightAnchor.constraint(equalTo: contentStackView.heightAnchor),
            sortButton.widthAnchor.constraint(equalTo: contentStackView.heightAnchor, constant: 16),
            
            sortButtonBadge.widthAnchor.constraint(equalToConstant: 8),
            sortButtonBadge.heightAnchor.constraint(equalTo: sortButtonBadge.widthAnchor),
            sortButtonBadge.topAnchor.constraint(equalTo: sortButton.topAnchor, constant: 8),
            sortButtonBadge.trailingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: -16),
        ])
    }
    
    @objc
    private func didTapSortButton(_ sender: UIButton) {
        delegate?.didTapSortButton(sender)
    }
}
