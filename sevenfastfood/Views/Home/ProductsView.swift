//
//  ProductsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

final class ProductsView: UICollectionView {
    private let cellIdentifier = "Product"
    var products: [Product]? = []
    {
        didSet(_value) {
            reloadData()
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        register(ProductViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
    }
}

extension ProductsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductViewCell
        let product = products?[indexPath.item]
        cell.productName = product?.name.en
        cell.productDescription = product?.category?.name.en
        cell.productPrice = "\(product!.price) VND"
        cell.productFeaturedImage = product?.featuredImages?.first
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width - 10) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
