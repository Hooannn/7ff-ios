//
//  CartItem.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func didChangeItemQuantity(_ newValue: Int,_ productId: String)
}

fileprivate class DeleteView: ClickableView {
    private lazy var trashImageView: UIImageView = {
        let image = UIImage(systemName: "trash")
        let view = UIImageView(image: image)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        backgroundColor = .alizarin
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.cornerRadius = 12
        addSubview(trashImageView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            trashImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trashImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    override func didTap(_ sender: UIGestureRecognizer) {
        debugPrint("did tap delete")
    }
}

class CartItemViewCell: BaseCollectionViewCell {
    weak var delegate: CartItemCellDelegate?
    private let debouncer = Debouncer(delay: 0.5)
    var productId: String?
    
    var isLoading: Bool?
    {
        didSet {
            if isLoading ?? false {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
    
    var name: String?
    {
        didSet {
            nameLabel.text = name
        }
    }
    
    var featuredImage: String?
    {
        didSet {
            featuredImageView.loadRemoteUrl(from: featuredImage)
        }
    }
    
    var category: String?
    {
        didSet {
            guard let category = category else { return }
            categoryLabel.text = category
        }
    }
    
    var unitPrice: Double?
    {
        didSet {
            guard let quantity = quantity, let unitPrice = unitPrice else { return }
            totalPrice = unitPrice * Double(quantity)
        }
    }
    
    var quantity: Int?
    {
        didSet {
            guard let quantity = quantity else { return }
            quantityInput.updateValue(quantity)
            guard let unitPrice = unitPrice else { return }
            totalPrice = unitPrice * Double(quantity)
        }
    }
    
    var totalPrice: Double?
    {
        didSet {
            guard let totalPrice = totalPrice else { return }
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: totalPrice as NSNumber) {
                totalPriceLabel.text = "\(formattedTotalPrice)"
            }
        }
    }
    
    private var originalCenter: CGPoint?
    
    private var trayOriginalCenter: CGPoint = .zero
    
    private lazy var featuredImageView: UIImageView = {
        let image = UIImage()
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.isSkeletonable = true
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.textAlignment = .left
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        label.text = String(totalPrice ?? 0)
        label.textColor = .alizarin
        return label
    }()
    
    private lazy var titleAndUnitPriceView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        return view
    }()
    
    private lazy var quantityInput: QuantityInputView = {
        let view = QuantityInputView()
        view.delegate = self
        return view
    }()
    
    private lazy var totalPriceAndQuantityView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [totalPriceLabel, quantityInput])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .trailing
        return view
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleAndUnitPriceView, totalPriceAndQuantityView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [featuredImageView, descriptionStackView])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.frame = self.bounds
        view.backgroundColor = UIColor(white: 1, alpha: 0.3)
        view.hidesWhenStopped = true
        return view
    }()
    
    private lazy var deleteView: DeleteView = {
        DeleteView()
    }()

    override func prepareForReuse() {
        hideLoading()
    }
    
    override func setupViews() {
        originalCenter = center
        contentView.addSubviews(contentStackView, loadingView, deleteView)
        addPanGesture()
        backgroundColor = .white
        clipsToBounds = false
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowColor = CGColor(gray: 1, alpha: 1)
        layer.shadowOpacity = 0.3
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            
            deleteView.widthAnchor.constraint(equalToConstant: 70),
            deleteView.heightAnchor.constraint(equalTo: heightAnchor),
            deleteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 82),

            featuredImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            featuredImageView.widthAnchor.constraint(equalTo: featuredImageView.heightAnchor),
            totalPriceAndQuantityView.heightAnchor.constraint(equalToConstant: 40),
            quantityInput.widthAnchor.constraint(equalTo: totalPriceAndQuantityView.widthAnchor, multiplier: 0.35),
            quantityInput.heightAnchor.constraint(equalTo: totalPriceAndQuantityView.heightAnchor, multiplier: 0.7),
            totalPriceLabel.heightAnchor.constraint(equalTo: totalPriceAndQuantityView.heightAnchor, multiplier: 0.7)
        ])
    }
    
    private func showLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.startAnimating()
        }
    }
    
    private func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.stopAnimating()
        }
    }
    
    private func addPanGesture() {
        let gesture = PanDirectionGestureRecognizer(direction: .horizontal, target: self, action: #selector(handlePanGesture(_:)))
        contentView.addGestureRecognizer(gesture)
    }
    
    private func backToOriginalState() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.center = self!.originalCenter!
        }
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: contentView)
        let threshold = 82
        if sender.state == .began {
            trayOriginalCenter = center
        } else if sender.state == .changed {
            // Swipe left only
            let maxCenterX = trayOriginalCenter.x
            let translationX = abs(translation.x) >= CGFloat(threshold) ? -CGFloat(threshold) : translation.x
            let offset = trayOriginalCenter.x + translationX
            let newCenterX = min(maxCenterX, offset)
            center = CGPoint(x: newCenterX, y: center.y)
        } else if sender.state == .ended {
            if abs(translation.x) >= CGFloat(threshold) {
                
            } else {
                backToOriginalState()
            }
        }
    }
}

extension CartItemViewCell: QuantityInputDelegate {
    func quantityInput(_ quantityInput: QuantityInputView, didChangeWithValue value: Int) {
        debouncer.debounce { [weak self] in guard let self = self else { return }
            if let productId = productId {
                delegate?.didChangeItemQuantity(value, productId)
            } else {
                Toast.shared.display(with: "Missing product id")
            }
        }
    }
}
