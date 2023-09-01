//
//  HeaderView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 15/08/2023.
//

import UIKit
import SkeletonView

fileprivate class DisplayImageView: ClickableView {
    var didTapAvatar: (() -> Void)?
    private lazy var imageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isSkeletonable = true
        return imageView
    }()
    
    func loadRemoteImageUrl(from avatar: String?) {
        imageView.loadRemoteUrl(from: avatar)
    }
    
    override func setupViews() {
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    override func didTap(_ sender: UIGestureRecognizer) {
        didTapAvatar?()
    }
}

final class HomeHeaderView: UIView {
    private var displayName: String?
    private var avatar: String?
    
    var didTapAvatar: (() -> Void)?
    private lazy var displayImageView: DisplayImageView = {
        let imageView = DisplayImageView()
        imageView.loadRemoteImageUrl(from: avatar)
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
        label.text = displayName
        label.tintColor = .black
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        return label
    }()
    

    convenience init(displayName name: String, avatar: String?) {
        self.init()
        self.avatar = avatar
        self.displayName = name
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
