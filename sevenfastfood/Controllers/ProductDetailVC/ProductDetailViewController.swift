//
//  ProductDetailViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import UIKit
final class ProductDetailViewController: ViewControllerWithoutNavigationBar {
    private lazy var safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
    private lazy var viewModel: ProductDetailViewModel = {
        let viewModel = ProductDetailViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private var cartViewModel: CartViewModel?
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.layer.zPosition = 10
        button.backgroundColor = .white
        button.tintColor = Tokens.shared.secondaryColor
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var cartButton: BadgeButton = {
        let button = BadgeButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        button.layer.zPosition = 10
        button.backgroundColor = .white
        button.tintColor = Tokens.shared.secondaryColor
        button.setImage(UIImage(named: "Cart"), for: .normal)
        button.addTarget(self, action: #selector(didTapCartButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCloseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var productId: String = ""
    private lazy var wasPresented: Bool = false
    
    private var productDetailView: ProductDetailView?

    init(productId: String, wasPresented: Bool) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.hidesBackButton = true
        self.productId = productId
        self.wasPresented = wasPresented
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        setupLoading()
        setupViews()
        setupConstraints()
    }
    
    private func setupLoading() {
        view.addSubview(loadingIndicator)
        if productId != "" {
            loadingIndicator.startAnimating()
            viewModel.fetchProductDetail(withId: productId)
        }
        if wasPresented {
            view.bringSubviewToFront(closeButton)
        } else {
            view.bringSubviewToFront(backButton)
        }
    }
    
    private func removeLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
        }
    }
    
    private func setupViews() {
        if wasPresented {
            view.addSubview(closeButton)
            setupCloseButtonConstraints()
        } else {
            view.addSubview(backButton)
            view.addSubview(cartButton)
            setupBackButtonConstraints()
            setupCartButtonConstraints()
            setupCartViewModel()
        }
    }
    
    private func setupCartViewModel() {
        self.cartViewModel = CartViewModel(delegate: self)
    }
    
    private func setupProductViews(withProduct product: Product?) {
        removeLoading()
        let topConstant = wasPresented ? CGFloat(50) : CGFloat(safeAreaInsets!.top + 50)
        let productDetailView = ProductDetailView(product: product, topConstant: topConstant)
        productDetailView.delegate = self
        self.productDetailView = productDetailView
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(productDetailView)
            NSLayoutConstraint.activate([
                productDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
                productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
            self.view.layoutIfNeeded()
            if self.wasPresented {
                self.view.bringSubviewToFront(self.closeButton)
            } else {
                self.view.bringSubviewToFront(self.backButton)
                self.view.bringSubviewToFront(self.cartButton)
            }
        }
    }
    
    private func setupCloseButtonConstraints() {
        let constraints: [NSLayoutConstraint] = [
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupCartButtonConstraints() {
        let constraints: [NSLayoutConstraint] = [
            cartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            cartButton.widthAnchor.constraint(equalToConstant: 50),
            cartButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupBackButtonConstraints() {
        let constraints: [NSLayoutConstraint] = [
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Tokens.shared.containerXPadding),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.layoutIfNeeded()
    }
    
    @objc func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCartButton(_ sender: UIButton) {
        dismiss(animated: true) {
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @objc func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func didFetchProductDetailFailure(_ error: Error) {
        Toast.shared.display(with: "Fetched product detail error: \(error.localizedDescription)")
    }
    
    func didFetchProductDetailSuccess(_ product: Product?) {
        setupProductViews(withProduct: product)
    }
}

extension ProductDetailViewController: ProductDetailViewDelegate {
    func didTapAddToCartButton(_ sender: UIButton) {
        productDetailView?.isAddingItem = true
        CartService.shared.addItem(productId: productId, quantity: 1) {
            [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                Toast.shared.display(with: "Added successfully")
            case .failure(let error):
                Toast.shared.display(with: "Something occured. \(error.localizedDescription.capitalized(with: .current))")
            }
            self.productDetailView?.isAddingItem = false
        }
    }
}

extension ProductDetailViewController: CartViewModelDelegate {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?) {
        let itemsCount = cartItems?.count ?? 0
        cartButton.badgeValue = itemsCount
    }
}
