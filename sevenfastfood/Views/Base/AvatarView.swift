//
//  AvatarView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 02/09/2023.
//

import UIKit

final class AvatarView: ClickableView {
    var didTapAvatar: (() -> Void)?
    lazy var imageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.isSkeletonable = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    func loadRemoteImageUrl(from avatar: String?) {
        imageView.loadRemoteUrl(from: avatar)
    }
    
    override func setupViews() {
        backgroundColor = .clear
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
    
    override func animateHoverEffect(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.alpha = 0.8
        }) {
            done in if done {
                completion?()
            }
        }
    }
    
    override func restoreOriginalState(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 1
        }) { _ in
            completion?()
        }
    }
}
