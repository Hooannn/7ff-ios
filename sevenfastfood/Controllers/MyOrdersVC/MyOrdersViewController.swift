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
        view.delegate = self
        return view
    }()
    
    private lazy var statusFilterView: OrdersStatusFilterView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        let view = OrdersStatusFilterView(frame: .zero, collectionViewLayout: layout, delegate: self)
        return view
    }()
    
    private lazy var orderViews: OrdersView = {
        let view = OrdersView(orderViewCellDelegate: self)
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let existedStatus = self.statusFilterView.selectedStatus {
            self.didSelectStatus(existedStatus)
        }
    }
    
    private func setupViewModel() {
        self.viewModel = MyOrdersViewModel(delegate: self)
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        view.addSubviews(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            statusFilterView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        view.layoutIfNeeded()
    }
}

extension MyOrdersViewController: MyOrdersViewModelDelegate, OrdersStatusFilterViewDelegate, OrderViewCellDelegate, OrdersHeaderViewDelegate {
    func didTapSearchButton(_ sender: UIButton) {
        openSearchViewController()
    }
    
    func didReceiveOrdersUpdate(_ orders: [Order]?) {
        let ordersCount = orders?.count ?? 0
        headerView.itemsCount = ordersCount
        orderViews.orders = orders
    }
    
    func didSelectStatus(_ status: OrderStatus) {
        orderViews.shouldShowOrdersWithStatus = status
    }
    
    func didTapDetailsButton(_ sender: UIButton, _ orderId: String) {
        let orderDetailVC = OrderDetailViewController(orderId: orderId)
        orderDetailVC.title = "Order Details"
        pushViewControllerWithoutBottomBar(orderDetailVC)
    }
}
