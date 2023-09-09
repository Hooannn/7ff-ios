//
//  OrderItemsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit
final class OrdersView: BaseView {
    var orders: [Order]? = []
    {
        didSet {
            ordersTableView.reloadData()
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
    
    override func setupViews() {
        addSubviews(ordersTableView)
        ordersTableView.register(OrderViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            ordersTableView.topAnchor.constraint(equalTo: topAnchor, constant: -6),
            ordersTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ordersTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ordersTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension OrdersView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? OrderViewCell
        if cell == nil {
            cell = OrderViewCell(style: .default, reuseIdentifier: identifier)
        }
        let order = orders?[indexPath.item]
        cell?.id = order?._id
        cell?.items = order?.items
        cell?.status = order?.status
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do stuff
        
        //
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
