//
//  CartItemsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

class CartItemsView: BaseView {
    private let identifier = "CartItems"
    private lazy var cartItemsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    var items: [CartItem]? = []
    {
        didSet(_old) {
            cartItemsCollectionView.reloadData()
        }
    }

    override func setupViews() {
        addSubviews(cartItemsCollectionView)
        cartItemsCollectionView.register(CartItemViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            cartItemsCollectionView.topAnchor.constraint(equalTo: topAnchor),
            cartItemsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cartItemsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cartItemsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension CartItemsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CartItemViewCell
        let item = items?[indexPath.item]
        cell.featuredImage = item?.product.featuredImages?.first
        cell.name = item?.product.name.en
        cell.quantity = item?.quantity
        cell.unitPrice = item?.product.price
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(bounds.width)
        let height = CGFloat(128)
        return CGSizeMake(width, height)
    }
}
