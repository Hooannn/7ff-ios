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
        let view = HomeHeaderView(displayName: "\(user!.lastName) \(user!.firstName)", avatar: user?.avatar)
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
        view.productCellDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        
        setupCategories()
    }
    
    private func setupCategories() {
        categoriesView.showAnimatedGradientSkeleton()
        viewModel.fetchCategories()
    }
    
    private func setupViews() {
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            headerView.heightAnchor.constraint(equalToConstant: 54),
            searchBarView.heightAnchor.constraint(equalToConstant: 54),
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
        productDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(productDetailVC, animated: true)
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
        let navigation = UINavigationController(rootViewController: searchVC)
        navigation.modalPresentationStyle = .fullScreen
        navigationController?.present(navigation, animated: true)
    }
}
