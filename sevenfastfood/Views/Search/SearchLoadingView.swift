//
//  SearchLoadingView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 05/09/2023.
//

import UIKit
class SearchLoadingView: BaseCollectionView {
    private let identifier = "SearchLoading"
    
    convenience init() {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        self.init(frame: .zero, collectionViewLayout: collectionViewLayout)
    }
    
    override func setupViews() {
        isSkeletonable = true
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        backgroundColor = .clear
        showAnimatedGradientSkeleton()
    }
}

extension SearchLoadingView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(bounds.width)
        let height = CGFloat(114)
        return CGSizeMake(width, height)
    }
}
