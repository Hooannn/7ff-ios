//
//  ProfileAvatarView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 02/09/2023.
//

import UIKit
class ProfileAvatarView: BaseView {
    var avatar: String?
    {
        didSet {
            avatarImageView.loadRemoteImageUrl(from: avatar)
        }
    }
    var displayName: String?
    {
        didSet {
            displayNameLabel.text = displayName
        }
    }
    
    private lazy var avatarImageView: AvatarView = {
        let imageView = AvatarView()
        imageView.didTapAvatar = {
            debugPrint("Godd")
        }
        return imageView
    }()
    
    private lazy var editIconView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 4
        container.clipsToBounds = true
        container.backgroundColor = Tokens.shared.secondaryColor
        let image = UIImage(named: "Edit")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        container.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
        ])
        return container
    }()
    
    private lazy var displayNameLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        
        return label
    }()
    
    private lazy var avatarAndDisplayNameView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, displayNameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()

    override func setupViews() {
        addSubviews(avatarAndDisplayNameView, editIconView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarAndDisplayNameView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarAndDisplayNameView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            avatarImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
            
            editIconView.heightAnchor.constraint(equalToConstant: 20),
            editIconView.widthAnchor.constraint(equalTo: editIconView.heightAnchor),
            editIconView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -15),
            editIconView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: -15),
        ])
    }
}
