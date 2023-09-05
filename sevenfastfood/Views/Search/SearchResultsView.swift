//
//  SearchResultsCollectionView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 04/09/2023.
//

import UIKit

fileprivate class SearchResultsCollectionHeaderView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = Widgets.shared.createLabel()
        label.font = UIFont.systemFont(ofSize: Tokens.shared.descriptionFontSize)
        label.text = "Results:"
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchResultsView: BaseView {
    private let identifier = "SearchResults"
    private lazy var searchResultsCollectionView: UICollectionView = {
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
    
    private lazy var searchEmptyView: SearchEmptyView = {
        let view = SearchEmptyView()
        return view
    }()
    
    private lazy var searchOnboardingView: SearchOnboardingView = {
        let view = SearchOnboardingView()
        return view
    }()
    
    private lazy var searchLoadingView: SearchLoadingView = {
        let view = SearchLoadingView()
        return view
    }()
    
    weak var searchTextField: UITextField?
    var isLoadingOrTyping: Bool?
    {
        didSet {
            if isLoadingOrTyping ?? false {
                showLoadingView()
            } else {
                if let searchTextField = searchTextField, searchTextField.hasText {
                    if items?.count ?? 0 > 0 {
                        showResultsView()
                    } else {
                        showEmptyView()
                    }
                } else {
                    showOnboardingView()
                }
            }
        }
    }

    var items: [Product]? = []
    {
        didSet {
            searchResultsCollectionView.reloadData()
        }
    }
    
    private func showLoadingView() {
        searchLoadingView.isHidden = false
        [
            searchResultsCollectionView, searchOnboardingView, searchEmptyView
        ].forEach {
            view in view.isHidden = true
        }
    }
    
    private func showEmptyView() {
        searchEmptyView.isHidden = false
        searchEmptyView.searchString = searchTextField?.text
        [
            searchResultsCollectionView, searchOnboardingView, searchLoadingView
        ].forEach {
            view in view.isHidden = true
        }
    }
    
    private func showOnboardingView() {
        searchOnboardingView.isHidden = false
        [
            searchResultsCollectionView, searchLoadingView, searchEmptyView
        ].forEach {
            view in view.isHidden = true
        }
    }
    
    private func showResultsView() {
        searchResultsCollectionView.isHidden = false
        [
            searchLoadingView, searchOnboardingView, searchEmptyView
        ].forEach {
            view in view.isHidden = true
        }
    }
    
    override func setupViews() {
        addSubviews(searchResultsCollectionView, searchLoadingView, searchOnboardingView, searchEmptyView)
        searchResultsCollectionView.backgroundColor = .clear
        searchResultsCollectionView.register(SearchItemViewCell.self, forCellWithReuseIdentifier: identifier)
        searchResultsCollectionView.register(SearchResultsCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
        
        showOnboardingView()
    }
    
    override func setupConstraints() {
        [searchResultsCollectionView, searchLoadingView, searchOnboardingView, searchEmptyView].forEach {
            view in
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}

extension SearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier, for: indexPath) as! SearchResultsCollectionHeaderView
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: frame.width, height: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! SearchItemViewCell
        let item = items?[indexPath.item]
        cell.productId = item?._id
        cell.featuredImage = item?.featuredImages?.first
        cell.name = item?.name.en
        cell.unitPrice = item?.price
        cell.category = item?.category?.name.en
        cell.viewThisMonth = item?.monthlyViewCount?.count ?? 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(bounds.width)
        let height = CGFloat(114)
        return CGSizeMake(width, height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}
