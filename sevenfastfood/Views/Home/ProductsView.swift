//
//  ProductsView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

final class ProductsView: BaseCollectionView {
    weak var productCellDelegate: ProductViewCellDelegate!
    private let cellIdentifier = "Product"
    var products: [Product]? = []
    {
        didSet {
            reloadData()
            DispatchQueue.main.async {
                [weak self] in
                self?.hideSkeleton()
            }
        }
    }
    
    override func setupViews() {
        dataSource = self
        isSkeletonable = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        register(ProductViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        register(PromotionsView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellIdentifier)
    }
}

extension ProductsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products!.count > 0 {
            return products?.count ?? 0
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProductViewCell
        if indexPath.item < products!.count {
            let product = products?[indexPath.item]
            cell.id = product?._id
            cell.delegate = productCellDelegate
            cell.name = product?.name.en
            cell.pdescription = product?.category?.name.en
            cell.price = product!.price
            cell.featuredImage = product?.featuredImages?.first
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width - 10) / 2
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: cellIdentifier, for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}
