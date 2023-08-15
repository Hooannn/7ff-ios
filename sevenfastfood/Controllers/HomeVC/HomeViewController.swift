//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    private lazy var safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
    
    private lazy var headerView: HomeHeaderView = {
        let view = HomeHeaderView(displayName: "Khai Hoan", displayImage: UIImage(named: "Profile")!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubviews(headerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
