//
//  CategoriesView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

protocol CategoriesViewDelegate: AnyObject {
    func didSelectCategory(_ category: Category?)
}
final class CategoriesView: UICollectionView {
    weak var categoryViewDelegate: CategoriesViewDelegate!
    private let cellIdentifier = "Category"
    var selectedCategoryIndex: Int = 0
    var categories: [Category]? = []
    {
        didSet(newValue) {
            let allCategory = Category(_id: "all", name: Content(vi: "Tất cả", en: "All"), description: Content(vi: "Tất cả", en: "All"), icon: nil)
            categories?.insert(allCategory, at: 0)
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
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(CategoryViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func setupConstraints() {
        
    }
}

extension CategoriesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        cell.label.text = categories?[indexPath.item].name.en
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CategoryViewCell
        let text = categories?[indexPath.item].name.en
        let textSize = text!.size(withAttributes: [
            NSAttributedString.Key.font: cell.label.font ?? UIFont.boldSystemFont(ofSize: 16)
        ])
        return CGSize(width: textSize.width + 5, height: textSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Did select item at \(indexPath.item)")
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = true
            let category = categories?[indexPath.item]
            categoryViewDelegate.didSelectCategory(category)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        debugPrint("Did deselect item at \(indexPath.item)")
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.isSelected = false
        }
    }
}
