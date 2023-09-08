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
            //ordersCollectionView.reloadData()
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
    
    /*
    private lazy var ordersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.backgroundColor = .clear
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    */
    
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
        return view
    }()
    
    override func setupViews() {
        /*
        addSubviews(ordersCollectionView)
        ordersCollectionView.register(OrderViewCell.self, forCellWithReuseIdentifier: identifier)
        */
        addSubviews(ordersTableView)
        ordersTableView.register(OrderViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        /*
        NSLayoutConstraint.activate([
            ordersCollectionView.topAnchor.constraint(equalTo: topAnchor),
            ordersCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ordersCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ordersCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        */
        NSLayoutConstraint.activate([
            ordersTableView.topAnchor.constraint(equalTo: topAnchor),
            ordersTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ordersTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ordersTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

/*
extension OrdersView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        orders?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderViewCell
        let order = orders?[indexPath.item]
        cell.id = order?._id
        cell.items = order?.items
        cell.status = order?.status
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderViewCell
        return CGSize(width: bounds.width, height: 100)
    }
}
*/

extension OrdersView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? OrderViewCell
        let cell = OrderViewCell(style: .default, reuseIdentifier: identifier)
        let order = orders?[indexPath.item]
        cell.id = order?._id
        cell.items = order?.items
        cell.status = order?.status
        return cell
    }
}
