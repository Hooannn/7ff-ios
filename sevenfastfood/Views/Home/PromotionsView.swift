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
final class PromotionsView: ClickableView {
    weak var delegate: PromotionsViewDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
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
        delegate.didTapPromotion(sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubviews(bannerImageView)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = 12
    }
}
