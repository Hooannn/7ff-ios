//
//  OrderDetailsItemsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 11/09/2023.
//

import UIKit
final class OrderDetailsItemsView: BaseView {
    private let identifier = "OrderDetailsItems"
    var items: [CartItem]?
    {
        didSet {
            itemsCollectionView.reloadData()
            itemsCollectionViewHeightConstraint?.constant = itemsCollectionView.collectionViewLayout.collectionViewContentSize.height
            layoutIfNeeded()
        }
    }
    private lazy var titleLabel: UILabel = {
        let label = Widgets.shared.createLabel()
        label.text = "Order items"
        label.font = UIFont.systemFont(ofSize: Tokens.shared.systemFontSize, weight: .medium)
        return label
    }()

    lazy var itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        collection.isUserInteractionEnabled = false
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.scrollIndicatorInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return collection
    }()
    var itemsCollectionViewHeightConstraint: NSLayoutConstraint?
    override func setupViews() {
        layer.cornerRadius = 12
        backgroundColor = .white
        addSubviews(titleLabel, itemsCollectionView)
        itemsCollectionView.register(OrderItemViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            itemsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            itemsCollectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            itemsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
        itemsCollectionViewHeightConstraint = itemsCollectionView.heightAnchor.constraint(equalToConstant: 1)
        itemsCollectionViewHeightConstraint?.isActive = true
        layoutIfNeeded()
    }
}

extension OrderDetailsItemsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        return CGSize(width: bounds.width - 40, height: 70)
    }
}
