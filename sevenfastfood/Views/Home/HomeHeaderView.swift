//
//  HeaderView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 15/08/2023.
//

import UIKit
import SkeletonView

final class HomeHeaderView: UIView {
    var user: User?
    {
        didSet {
            displayImageView.loadRemoteImageUrl(from: user?.avatar)
            if let firstName = user?.firstName, let lastName = user?.lastName {
                displayNameLabel.text = "\(firstName) \(lastName)"
            }
        }
    }
    var didTapAvatar: (() -> Void)?
    private lazy var displayImageView: AvatarView = {
        let imageView = AvatarView()
        imageView.didTapAvatar = {
            self.didTapAvatar?()
        }
        return imageView
    }()
    
    private lazy var greetingView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [welcomeLabel, displayNameLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
    }()
    
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
        addSubviews(greetingView, displayImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            displayImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            displayImageView.topAnchor.constraint(equalTo: topAnchor),
            displayImageView.heightAnchor.constraint(equalTo: heightAnchor),
            displayImageView.widthAnchor.constraint(equalTo: heightAnchor),
            
            greetingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            greetingView.trailingAnchor.constraint(equalTo: displayImageView.leadingAnchor),
            greetingView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
