//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class CartViewController: ViewControllerWithoutNavigationBar {
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    private lazy var headerView: CartHeaderView = {
        let view = CartHeaderView()
        return view
    }()
    
    private lazy var discountProgressView: CartDiscountProgressView = {
        let view = CartDiscountProgressView()
        return view
    }()
    
    private var viewModel: CartViewModel?

    private lazy var cartItemsView: CartItemsView = {
        let view = CartItemsView()
        view.cartItemCellDelegate = self
        return view
    }()
    
    private lazy var emptyView: CartEmptyView = {
        let view = CartEmptyView()
        view.isHidden = true
        view.backgroundColor = .clear
        view.didTapShoppingButton = {
            self.tabBarController?.selectedIndex = 0
        }
        return view
    }()
    
    private lazy var footerView: CartFooterView = {
        let view = CartFooterView()
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, discountProgressView, cartItemsView, footerView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupViews()
        setupConstraints()
    }
    
    private func setupViewModel() {
        self.viewModel = CartViewModel(delegate: self)
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        view.addSubviews(containerView, emptyView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            discountProgressView.heightAnchor.constraint(equalToConstant: 34),
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
        discountProgressView.totalPrice = totalPrice ?? 0.0
    }
    
    private func displayEmptyView() {
        containerView.isHidden = true
        emptyView.isHidden = false
    }
    
    private func hideEmptyView() {
        containerView.isHidden = false
        emptyView.isHidden = true
    }
}

extension CartViewController: CartViewModelDelegate, CartItemCellDelegate {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?) {
        let cartItemsCount = cartItems?.count ?? 0
        headerView.itemsCount = cartItemsCount
        cartItemsView.items = cartItems
        self.updateTotalPrice(with: cartItems)
        
        if cartItemsCount > 0 {
            hideEmptyView()
        } else {
            displayEmptyView()
        }
    }
    
    func didChangeItemQuantity(_ newValue: Int,_ productId: String) {
        cartItemsView.setCellLoading(isLoading: true, with: productId)
        viewModel?.updateCartItemQuantity(newValue, productId)
    }
    
    func didConfirmItemDeletion(_ productId: String) {
        cartItemsView.setCellLoading(isLoading: true, with: productId)
        viewModel?.deleteCartItem(for: productId)
    }
    
    func didUpdateCartItemSuccess(_ productId: String,_ cartItems: [CartItem]?) {
        cartItemsView.setCellLoading(isLoading: false, with: productId)
    }
    
    func didUpdateCartItemFailure(_ productId: String,_ error: Error) {
        cartItemsView.setCellLoading(isLoading: false, with: productId)
        Toast.shared.display(with: "Updated failure due to \(error.localizedDescription) for product with \(productId)")
    }
}
