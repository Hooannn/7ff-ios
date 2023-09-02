//
//  ProductDetailView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import UIKit
import ImageSlideshow
import Cosmos
protocol ProductDetailViewDelegate: AnyObject {
    func didTapAddToCartButton(_ sender: UIButton)
}
class ProductDetailView: UIView {
    weak var delegate: ProductDetailViewDelegate?
    var isAddingItem: Bool = false
    {
        didSet {
            addToCartButton.setLoading(isAddingItem)
        }
    }
    private lazy var product: Product? = nil
    private var topConstant: CGFloat!
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleView: UIStackView = {
        let categoryLabel = Widgets.shared.createLabel()
        categoryLabel.text = product?.category?.name.en
        categoryLabel.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = product?.name.en
        titleLabel.font = UIFont.boldSystemFont(ofSize: Tokens.shared.titleFontSize)
        let stackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var featuredImagesView: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        slideshow.translatesAutoresizingMaskIntoConstraints = false
        let featuredImageSources = product?.featuredImages?.compactMap { image in AlamofireSource(urlString: image) }
        if let featuredImageSources = featuredImageSources {
            slideshow.setImageInputs(featuredImageSources)
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFeaturedImages(_:)))
        slideshow.addGestureRecognizer(recognizer)
        return slideshow
    }()
    
    private lazy var ratingView: CosmosView = {
        let view = CosmosView()
        if let rating = product?.rating {
            view.rating = rating
            view.text = "(\(rating))"
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.settings.fillMode = .half
        view.settings.starMargin = 5
        view.settings.starSize = 18
        view.settings.updateOnTouch = false
        view.settings.disablePanGestures = true
        return view
    }()
    
    private lazy var descriptionView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Product Description"
        titleLabel.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        
        let descriptionLabel = Widgets.shared.createLabel()
        if let description = product?.description.en {
            descriptionLabel.text = description
        }
        descriptionLabel.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        
        let view = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        view.axis = .vertical
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [featuredImagesView, titleView, ratingView, descriptionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = Widgets.shared.createPrimaryButton(title: "Add to card", target: self, action: #selector(didTapAddToCartButton(_:)))
        return button
    }()
    
    private lazy var priceView: UIStackView = {
        let titleLabel = Widgets.shared.createLabel()
        titleLabel.text = "Price"
        titleLabel.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize)
        let priceLabel = Widgets.shared.createLabel()
        if let price = product?.price {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedPrice = formatter.string(from: price as NSNumber) {
                priceLabel.text = "\(formattedPrice)"
            }
        }
        priceLabel.font = UIFont.systemFont(ofSize: Tokens.shared.titleFontSize, weight: .bold)
        
        let view = UIStackView(arrangedSubviews: [titleLabel, priceLabel])
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(product: Product?, topConstant: CGFloat) {
        self.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.topConstant = topConstant
        self.product = product
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        footerView.addSubviews(priceView, addToCartButton)
        scrollView.addSubviews(contentStackView)
        addSubviews(footerView, scrollView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 120),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: topConstant + 20),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            scrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            featuredImagesView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4),
            featuredImagesView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            addToCartButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            addToCartButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            addToCartButton.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.4),
            addToCartButton.heightAnchor.constraint(equalTo: footerView.heightAnchor, multiplier: 0.45),
            
            priceView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
            priceView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: Tokens.shared.containerXPadding),
            priceView.trailingAnchor.constraint(equalTo: addToCartButton.leadingAnchor),
        ])
    }
    
    @objc func didTapFeaturedImages(_ sender: UITapGestureRecognizer) {
        
    }
    
    @objc func didTapAddToCartButton(_ sender: UIButton) {
        delegate?.didTapAddToCartButton(sender)
    }
}

extension ProductDetailView: ImageSlideshowDelegate {
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        
    }
}
