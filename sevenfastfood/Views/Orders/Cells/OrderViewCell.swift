//
//  OrderViewCell.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import UIKit
fileprivate class OrderStatusView: BaseView {
    var state: OrderStatus?
    {
        didSet {
            let (title, color) = self.defineStatusTokens(for: state ?? .All)
            label.text = title
            label.textColor = color
            dotView.backgroundColor = color
        }
    }
    
    private func defineStatusTokens(for status: OrderStatus) -> (String, UIColor) {
        switch status {
        case .Cancelled:
            return ("CANCELLED", .systemRed)
        case .Delivering:
            return ("ON DELIVERY", .systemBlue)
        case .Done:
            return ("DONE", .systemGreen)
        case .Processing:
            return ("BEING PROCESSED", .systemYellow)
        default:
            return ("UNKNOWN", Tokens.shared.secondaryColor)
        }
    }
    
    private lazy var dotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize, weight: .medium)
        return label
    }()
    
    override func setupViews() {
        addSubviews(dotView, label)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalTo: dotView.widthAnchor),
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            label.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

final class OrderViewCell: BaseTableViewCell {
    private let identifier = "OrderItem"
    var id: String?
    {
        didSet {
            orderIdLabel.text = "Order ID #\(id?.prefix(6) ?? "None")"
        }
    }
    
    var status: OrderStatus? {
        didSet {
            statusView.state = status
        }
    }
    
    var items: [CartItem]?
    {
        didSet {
            orderItemsCollectionView.reloadData()
            ordersCollectionViewHeightConstraint?.constant = orderItemsCollectionView.collectionViewLayout.collectionViewContentSize.height
            layoutIfNeeded()
        }
    }
    
    var ordersCollectionViewHeightConstraint: NSLayoutConstraint?
    private lazy var orderIdLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.font = UIFont.boldSystemFont(ofSize: Tokens.shared.systemFontSize)
        return label
    }()
    
    private lazy var statusView: OrderStatusView = {
        let view = OrderStatusView()
        return view
    }()
    
    private lazy var detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Details", for: .normal)
        button.addTarget(self, action: #selector(didTapDetailButton(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var headerView: UIStackView = {
        let titleAndStatus = UIStackView(arrangedSubviews: [orderIdLabel, statusView])
        titleAndStatus.axis = .vertical
        titleAndStatus.translatesAutoresizingMaskIntoConstraints = false
        let view = UIStackView(arrangedSubviews: [titleAndStatus, detailButton])
        view.axis = .horizontal
        view.distribution = .equalCentering
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var orderItemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.scrollIndicatorInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return collection
    }()
    
    override func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowColor = UIColor.systemGray6.cgColor
        contentView.addSubviews(headerView, orderItemsCollectionView)
        orderItemsCollectionView.register(OrderItemViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            statusView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.5),
            
            orderItemsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            orderItemsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            orderItemsCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            orderItemsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
        ordersCollectionViewHeightConstraint = orderItemsCollectionView.heightAnchor.constraint(equalToConstant: 1)
        ordersCollectionViewHeightConstraint?.isActive = true
        layoutIfNeeded()
    }
    
    @objc private func didTapDetailButton(_ sender: UIButton) {
        debugPrint("Tapped detail")
    }
}

extension OrderViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! OrderItemViewCell
        let item = items?[indexPath.item]
        cell.featuredImage = item?.product.featuredImages?.first
        cell.title = item?.product.name.en
        cell.unitPrice = item?.product.price
        cell.quantity = item?.quantity
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: 70)
    }
}
