//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class HomeViewController: ViewControllerWithoutNavigationBar {
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    private let localDataClient = LocalData.shared
    private lazy var viewModel: HomeViewModel = {
        let viewModel = HomeViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView, searchBarView, categoriesView, productsView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    
    private lazy var headerView: HomeHeaderView = {
        let user = localDataClient.getLoggedUser()
        let view = HomeHeaderView()
        view.didTapAvatar = {
            self.tabBarController?.selectedIndex = 3
        }
        return view
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        view.delegate = self
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

    private lazy var productsView: ProductsView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = ProductsView(frame: .zero, collectionViewLayout: layout)
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        view.productCellDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUser()
    }
    
    private func setupUser() {
        let user = LocalData.shared.getLoggedUser()
        headerView.user = user
    }
    
    private func setupCategories() {
        categoriesView.showAnimatedGradientSkeleton()
        viewModel.fetchCategories()
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            searchBarView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            categoriesView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        view.layoutIfNeeded()
    }
}

extension HomeViewController: HomeViewModelDelegate, CategoriesViewDelegate, ProductViewCellDelegate {
    func didFetchCategoriesFailure(_ error: Error) {
        Toast.shared.display(with: "Fetched categories error: \(error.localizedDescription)")
    }
    
    func didFetchCategoriesSuccess(_ categories: [Category]?) {
        categoriesView.categories = categories
    }
    
    func didFetchProductsSuccess(_ products: [Product]?) {
        productsView.products = products
    }
    
    func didFetchProductsFailure(_ error: Error) {
        Toast.shared.display(with: "Fetched products error: \(error.localizedDescription)")
    }
    
    func didSelectCategory(_ category: Category?) {
        var queryDict: [String: Any] = [
            "isAvailable": true
        ]
        if category?._id != "all" {
            queryDict["category"] = [
                "_id": category!._id
            ]
        }
        let params = [
            "filter": Utils.shared.dictionaryToJson(queryDict)!
        ]
        viewModel.fetchProducts(withParams: params)
        productsView.showAnimatedGradientSkeleton()
    }
    
    private func createProductDetailVC(withId productId: String?, wasPresented: Bool) -> ProductDetailViewController {
        let vc = ProductDetailViewController(productId: productId!, wasPresented: wasPresented)
        return vc
    }
    
    func didTapCartButton(withId productId: String?) {
        didEndLongPressOnProduct(withId: productId)
    }
    
    func didTapOnProduct(withId productId: String?) {
        let productDetailVC = createProductDetailVC(withId: productId, wasPresented: false)
        pushViewControllerWithoutBottomBar(productDetailVC)
    }
    
    func didEndLongPressOnProduct(withId productId: String?) {
        let productDetailVC = createProductDetailVC(withId: productId, wasPresented: true)
        let nav = UINavigationController(rootViewController: productDetailVC)

        if #available(iOS 15.0, *) {
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = CGFloat(12)
            }
            present(nav, animated: true)
        } else {
            didTapOnProduct(withId: productId)
        }
    }
}

extension HomeViewController: SearchBarViewDelegate {
    func didTapSearchBar(_ sender: UIGestureRecognizer) {
        let searchVC = SearchViewController()
        let navigationVC = UINavigationController(rootViewController: searchVC)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationController?.present(navigationVC, animated: true)
    }
}
