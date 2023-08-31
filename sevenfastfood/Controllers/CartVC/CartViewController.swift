//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class CartViewController: ViewControllerWithoutNavigationBar {
    private var viewModel: CartViewModel?

    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    private lazy var headerView: CartHeaderView = {
        let view = CartHeaderView()
        return view
    }()
    
    private lazy var cartItemsView: CartItemsView = {
        let view = CartItemsView()
        view.cartItemCellDelegate = self
        return view
    }()
    
    private lazy var footerView: CartFooterView = {
        let view = CartFooterView()
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, cartItemsView, footerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        setupViewModel()
        setupViews()
        setupConstraints()
    }
    
    private func setupViewModel() {
        self.viewModel = CartViewModel(delegate: self)
    }
    
    private func setupViews() {
        view.addSubviews(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            footerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        view.layoutIfNeeded()
    }
    
    private func updateTotalPrice(with cartItems: [CartItem]?) {
        let totalPrice = cartItems?.reduce(0.0) {
            (result, cartItem) in
            let next = Double(cartItem.quantity) * cartItem.product.price
            return result + next
        }
        footerView.totalPrice = totalPrice ?? 0.0
    }
}

extension CartViewController: CartViewModelDelegate, CartItemCellDelegate {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?) {
        headerView.itemsCount = cartItems?.count ?? 0
        cartItemsView.items = cartItems
        
        self.updateTotalPrice(with: cartItems)
    }
    
    func didChangeItemQuantity(_ newValue: Int,_ productId: String) {
        cartItemsView.setCellLoading(isLoading: true, with: productId)
        viewModel?.updateCartItemQuantity(newValue, productId)
    }
    
    func didUpdateCartItemSuccess(_ productId: String,_ cartItems: [CartItem]?) {
        cartItemsView.setCellLoading(isLoading: false, with: productId)
    }
    
    func didUpdateCartItemFailure(_ productId: String,_ error: Error) {
        cartItemsView.setCellLoading(isLoading: false, with: productId)
        Toast.shared.display(with: "Updated failure due to \(error.localizedDescription) for product with \(productId)")
    }
}
