//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
    private let localDataClient = LocalData.shared
    private lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView, searchBarView, categoriesView, promotionsView, productsView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    
    private lazy var headerView: HomeHeaderView = {
        let user = localDataClient.getLoggedUser()
        let view = HomeHeaderView(displayName: "\(user!.lastName) \(user!.firstName)", displayImage: UIImage(named: "Profile")!, avatar: user?.avatar)
        return view
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        return view
    }()
    
    private lazy var categoriesView: CategoriesView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = CategoriesView(frame: .zero, collectionViewLayout: layout)
        view.categoryViewDelegate = self
        return view
    }()
    
    private lazy var promotionsView: PromotionsView = {
        let view = PromotionsView()
        return view
    }()
    
    private lazy var productsView: ProductsView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = ProductsView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        
        viewModel.fetchCategories()
        viewModel.fetchProducts()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            
            headerView.heightAnchor.constraint(equalToConstant: 54),
            searchBarView.heightAnchor.constraint(equalToConstant: 54),
            categoriesView.heightAnchor.constraint(equalToConstant: 36),
            promotionsView.heightAnchor.constraint(equalToConstant: 160),
            productsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
}

extension HomeViewController: HomeViewModelDelegate, CategoriesViewDelegate {
    func didFetchedCategoriesFailure(_ error: Error) {
        debugPrint("Fetched categories error: \(error)")
    }
    
    func didFetchedCategoriesSuccess(_ categories: [Category]?) {
        categoriesView.categories = categories
    }
    
    func didFetchedProductsSuccess(_ products: [Product]?) {
        productsView.products = products
    }
    
    func didFetchedProductsFailure(_ error: Error) {
        debugPrint("Fetched products error: \(error)")
    }
    
    func didSelectCategory(_ category: Category?) {
        debugPrint("Selected category \(category!._id!)")
    }
}
