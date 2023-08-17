//
//  HeaderView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 15/08/2023.
//

import UIKit

final class HomeHeaderView: UIView {
    private var displayName: String?
    private var displayImage: UIImage?
    private var avatar: String?
    private lazy var displayImageView: UIImageView = {
        let imageView = UIImageView(image: displayImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var greetingView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [welcomeTextView, displayNameTextView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4
        return view
    }()
    
    private lazy var welcomeTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var displayNameTextView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = displayName
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
    }()
    

    convenience init(displayName name: String, displayImage image: UIImage, avatar: String?) {
        self.init()
        self.avatar = avatar
        self.displayName = name
        self.displayImage = image
        setupViews()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        displayImageView.loadRemoteUrl(from: avatar)
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
