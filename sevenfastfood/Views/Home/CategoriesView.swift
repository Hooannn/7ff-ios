//
//  CategoriesView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit
import SkeletonView

protocol CategoriesViewDelegate: AnyObject {
    func didSelectCategory(_ category: Category?)
}
final class CategoriesView: UICollectionView {
    weak var categoryViewDelegate: CategoriesViewDelegate!
    private let cellIdentifier = "Category"
    var selectedCategory: Category?
    {
        didSet {
            categoryViewDelegate.didSelectCategory(selectedCategory)
        }
    }
    var categories: [Category]? = []
    {
        didSet(oldValue) {
            if oldValue!.count == 0 {
                let allCategory = Category(_id: "all", name: Content(vi: "Tất cả", en: "All"), description: Content(vi: "Tất cả", en: "All"), icon: nil)
                categories?.insert(allCategory, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                reloadData()
                DispatchQueue.main.async {
                    [weak self] in
                    self?.hideSkeleton()
                    self?.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
                    self?.selectedCategory = allCategory
                }
            } else {
                reloadData()
            }
        }
    }
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        isSkeletonable = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(CategoryViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension CategoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categories!.count > 0 {
            return categories?.count ?? 0
        } else {
            return 10
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        cellIdentifier
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        if indexPath.item < categories!.count {
            let category = categories?[indexPath.item]
            cell.label.text = category?.name.en
            if category?._id == selectedCategory?._id {
                cell.isSelected = true
            }
        } else {
            cell.label.text = "Loading"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        var text: String?
        if indexPath.item < categories!.count {
            text = categories?[indexPath.item].name.en
            let textSize = text!.size(withAttributes: [
                NSAttributedString.Key.font: cell.label.font ?? UIFont.boldSystemFont(ofSize: 16)
            ])
            return CGSize(width: textSize.width + 5, height: textSize.height)
        } else {
            return CGSize(width: 70, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = true
            let category = categories?[indexPath.item]
            selectedCategory = category
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = false
        }
    }
}
