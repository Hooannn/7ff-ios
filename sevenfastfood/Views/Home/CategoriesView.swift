//
//  CategoriesView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import UIKit

final class CategoryViewCell: UICollectionViewCell {
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private let dotView: UIView = {
        let dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.layer.cornerRadius = 4
        dot.backgroundColor = .black
        dot.isHidden = true
        return dot
    }()
    
    func setSelected(_ isSelected: Bool) {
        if isSelected {
            label.textColor = .black
            dotView.isHidden = false
        } else {
            label.textColor = .systemGray2
            dotView.isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(label, dotView)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7),
            
            dotView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dotView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            dotView.widthAnchor.constraint(equalTo: dotView.heightAnchor),
            dotView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8)
        ])
    }
}

final class CategoriesView: UICollectionView {
    private let cellIdentifier = "Category"
    var selectedCategoryIndex: Int = 0
    var categories: [Category]? = []
    {
        didSet(newValue) {
            let allCategory = Category(name: Content(vi: "Tất cả", en: "All"), description: Content(vi: "Tất cả", en: "All"), icon: nil)
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
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.setSelected(true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryViewCell {
            cell.setSelected(false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
}
