//
//  CartItemsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 25/08/2023.
//

import UIKit

class CartItemsView: BaseView {
    weak var cartItemCellDelegate: CartItemCellDelegate?
    private let identifier = "CartItems"
    private lazy var cartItemsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    var items: [CartItem]? = []
    {
        didSet {
            cartItemsCollectionView.reloadData()
        }
    }
    
    func setCellLoading(isLoading: Bool, with productId: String) {
        guard let row = items?.firstIndex(where: { cartItem in cartItem.product._id == productId }) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = cartItemsCollectionView.cellForItem(at: indexPath) as? CartItemViewCell else { return }
        cell.isLoading = isLoading
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
        cell.productId = item?.product._id
        cell.featuredImage = item?.product.featuredImages?.first
        cell.name = item?.product.name.en
        cell.quantity = item?.quantity
        cell.unitPrice = item?.product.price
        cell.category = item?.product.category?.name.en
        cell.delegate = cartItemCellDelegate
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(bounds.width)
        let height = CGFloat(114)
        return CGSizeMake(width, height)
    }
}
