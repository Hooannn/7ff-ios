//
//  OrderItemsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit
final class OrdersView: BaseView {
    weak var orderViewCellDelegate: OrderViewCellDelegate?
    var orders: [Order]? = []
    private var shouldShowOrders: [Order]? = []
    {
        didSet {
            ordersTableView.reloadData()
            if shouldShowOrders?.count ?? 0 > 0 {
                hideEmptyView()
            } else {
                displayEmptyView(with: shouldShowOrdersWithStatus)
            }
        }
    }

    var shouldShowOrdersWithStatus: OrderStatus?
    {
        didSet {
            if orders?.count ?? 0 < 0 { return }
            guard let shouldShowOrdersWithStatus = shouldShowOrdersWithStatus else { return }
            if shouldShowOrdersWithStatus == .All {
                shouldShowOrders = orders
            } else {
                shouldShowOrders = orders?.filter {
                    order in
                    order.status == shouldShowOrdersWithStatus
                }
            }
        }
    }
    
    private let identifier = "Orders"
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private lazy var ordersTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.delegate = self
        view.backgroundColor = .clear
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.rowHeight = UITableView.automaticDimension;
        view.estimatedRowHeight = 200;
        view.alwaysBounceVertical = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        return view
    }()
    
    private lazy var emptyView: OrdersEmptyView = {
        let view = OrdersEmptyView()
        view.isHidden = true
        view.backgroundColor = .clear
        return view
    }()
    
    convenience init(orderViewCellDelegate: OrderViewCellDelegate? = nil) {
        self.init(frame: .zero)
        self.orderViewCellDelegate = orderViewCellDelegate
    }
    
    override func setupViews() {
        addSubviews(ordersTableView, emptyView)
        ordersTableView.register(OrderViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    private func displayEmptyView(with status: OrderStatus?) {
        ordersTableView.isHidden = true
        emptyView.isHidden = false
        if status != .All {
            if let status = status?.rawValue {
                emptyView.title = "You don't have any orders with status '\(status)'"
            }
        } else {
            emptyView.title = "You don't have any orders"
        }
    }
    
    private func hideEmptyView() {
        ordersTableView.isHidden = false
        emptyView.isHidden = true
    }
    
    override func setupConstraints() {
        [emptyView, ordersTableView].forEach {
            view in
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor, constant: -6),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

extension OrdersView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shouldShowOrders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? OrderViewCell
        if cell == nil {
            cell = OrderViewCell(style: .default, reuseIdentifier: identifier)
        }
        let order = shouldShowOrders?[indexPath.item]
        cell?.id = order?._id
        cell?.items = order?.items
        cell?.status = order?.status
        cell?.delegate = orderViewCellDelegate
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = shouldShowOrders?[indexPath.item]
        if let id = order?._id {
            orderViewCellDelegate?.didTapDetailsButton(UIButton(), id)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 12
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 12
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}
