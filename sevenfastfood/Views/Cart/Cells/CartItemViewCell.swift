//
//  CartItem.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

protocol CartItemCellDelegate: AnyObject {
    func didChangeItemQuantity(_ newValue: Int,_ productId: String)
    func didConfirmItemDeletion(_ productId: String)
}

fileprivate class DeleteView: ClickableView {
    private lazy var trashImageView: UIImageView = {
        let image = UIImage(systemName: "trash")
        let view = UIImageView(image: image)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var didConfirmDeletion: ((UIAlertAction) -> Void)?
    
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
        let alertVC = UIAlertController(title: "Delete confirmation", message: "Are you sure you want to delete this item ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let acceptAction = UIAlertAction(title: "Delete", style: .destructive, handler: didConfirmDeletion)
        alertVC.addAction(cancelAction)
        alertVC.addAction(acceptAction)
        if let root = UIApplication.shared.keyWindow?.rootViewController {
            root.present(alertVC, animated: true)
        }
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
    
    private lazy var titleAndCategoryView: UIStackView = {
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
        let view = UIStackView(arrangedSubviews: [titleAndCategoryView, totalPriceAndQuantityView])
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
        let view = DeleteView()
        view.didConfirmDeletion = {
            [weak self] _ in guard let productId = self?.productId else { return }
            self?.backToOriginalState {
                self?.delegate?.didConfirmItemDeletion(productId)
            }
        }
        return view
    }()
    
    override func prepareForReuse() {
        hideLoading()
        backToOriginalState()
        originalCenter = center
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isHidden || alpha == 0 || clipsToBounds { return super.hitTest(point, with: event) }
        // convert the point into subview's coordinate system
        let subviewPoint = self.convert(point, to: deleteView)
        // if the converted point lies in subview's bound, tell UIKit that subview should be the one that receives this event
        if !deleteView.isHidden && deleteView.bounds.contains(subviewPoint) { return deleteView }
        return super.hitTest(point, with: event)
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
    
    private func backToOriginalState(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.center.x = self!.originalCenter!.x
        }) {
            _ in
            completion?()
        }
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: contentView)
        let threshold = CGFloat(82)
        if sender.state == .began {
            trayOriginalCenter = center
        } else if sender.state == .changed {
            let maxCenterX = originalCenter!.x
            let minCenterX = originalCenter!.x - threshold
            let translationX = translation.x <= -threshold ? -threshold : translation.x
            let offset = trayOriginalCenter.x + translationX <= minCenterX ? minCenterX : trayOriginalCenter.x + translationX
            let newCenterX = min(maxCenterX, offset)
            center = CGPoint(x: newCenterX, y: center.y)
        } else if sender.state == .ended {
            if translation.x <= -threshold {
                
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
                backToOriginalState()
                delegate?.didChangeItemQuantity(value, productId)
            } else {
                Toast.shared.display(with: "Missing product id")
            }
        }
    }
}
