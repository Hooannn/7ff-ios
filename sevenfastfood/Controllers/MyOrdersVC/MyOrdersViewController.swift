//
//  MyOrdersViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 03/09/2023.
//

import UIKit

final class MyOrdersViewController: ViewControllerWithoutNavigationBar {
    private var viewModel: MyOrdersViewModel?
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    
    private lazy var headerView: OrdersHeaderView = {
        let view = OrdersHeaderView()
        return view
    }()
    
    private lazy var statusFilterView: OrdersStatusFilterView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        let view = OrdersStatusFilterView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private lazy var orderViews: OrdersView = {
        let view = OrdersView()
        return view
    }()
    
    private lazy var emptyView: OrdersEmptyView = {
        let view = OrdersEmptyView()
        view.isHidden = true
        view.backgroundColor = .clear
        view.didTapShoppingButton = {
            self.tabBarController?.selectedIndex = 0
        }
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerView, statusFilterView, orderViews])
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
        self.viewModel = MyOrdersViewModel(delegate: self)
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
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            statusFilterView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        view.layoutIfNeeded()
    }
}

extension MyOrdersViewController: MyOrdersViewModelDelegate {
    func didReceiveOrdersUpdate(_ orders: [Order]?) {
        let ordersCount = orders?.count ?? 0
        headerView.itemsCount = ordersCount
        orderViews.orders = orders
    }
}
