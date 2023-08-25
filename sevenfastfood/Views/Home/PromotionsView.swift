//
//  PromotionsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit
protocol PromotionsViewDelegate: AnyObject {
    func didTapPromotion(_ sender: UIGestureRecognizer)
}
final class PromotionsView: ClickableCollectionReusableView {
    weak var delegate: PromotionsViewDelegate!
    
    private lazy var bannerImageView: UIImageView = {
        let image = UIImage(named: "Promotion_banner")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    override func didTap(_ sender: UIGestureRecognizer) {
        super.didTap(sender)
    }
    
    override func setupViews() {
        addSubviews(bannerImageView)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 12
    }
}
