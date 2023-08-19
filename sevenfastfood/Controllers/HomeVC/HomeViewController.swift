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
        let view = HomeHeaderView(displayName: "\(user!.lastName) \(user!.firstName)", avatar: user?.avatar)
        return view
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        view.delegate = self
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var categoriesView: CategoriesView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        let view = CategoriesView(frame: .zero, collectionViewLayout: layout)
        view.categoryViewDelegate = self
        return view
    }()
    
    private lazy var promotionsView: PromotionsView = {
        let view = PromotionsView()
        view.delegate = self
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
    }
    
    private func setupViews() {
        //scrollView.addSubviews(promotionsView, productsView)
        view.addSubview(containerView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        categoriesView.showAnimatedGradientSkeleton()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            headerView.heightAnchor.constraint(equalToConstant: 54),
            searchBarView.heightAnchor.constraint(equalToConstant: 54),
            categoriesView.heightAnchor.constraint(equalToConstant: 36),
            promotionsView.heightAnchor.constraint(equalToConstant: 160),
        ])
        
        view.layoutIfNeeded()
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
        if category?._id == "all" {
            viewModel.fetchProducts(withParams: nil)
        } else {
            let queryDict = [
                "category": [
                    "_id": category!._id!
                ]
            ]
            let params = [
                "filter": Utils.shared.dictionaryToJson(queryDict)!
            ]
            viewModel.fetchProducts(withParams: params)
        }
        productsView.showAnimatedGradientSkeleton()
    }
}

extension HomeViewController: SearchBarViewDelegate, PromotionsViewDelegate {
    func didTapPromotion(_ sender: UIGestureRecognizer) {
        
    }
    
    func didTapSearchBar(_ sender: UIGestureRecognizer) {
        let searchVC = SearchViewController()
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.modalPresentationStyle = .fullScreen
        navigationController?.present(navigation, animated: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
}
