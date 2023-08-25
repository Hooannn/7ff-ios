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
        view.backgroundColor = .systemBackground
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
}

extension CartViewController: CartViewModelDelegate {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?) {
        headerView.itemsCount = cartItems?.count ?? 0
        cartItemsView.items = cartItems
    }
}
