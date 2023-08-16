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
    private let viewModel = HomeViewModel()
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [headerView, searchBarView, categoriesView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    
    private lazy var headerView: HomeHeaderView = {
        let user = localDataClient.getLoggedUser()
        let view = HomeHeaderView(displayName: "\(user!.lastName) \(user!.firstName)", displayImage: UIImage(named: "Profile")!, avatar: user?.avatar)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var searchBarView: SearchBarView = {
        let view = SearchBarView()
        return view
    }()
    
    private lazy var categoriesView: CategoriesView = {
        let view = CategoriesView()
        view.backgroundColor = .black
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
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top + 16),
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
            headerView.heightAnchor.constraint(equalToConstant: 54),
            searchBarView.heightAnchor.constraint(equalToConstant: 54),
            categoriesView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
}
