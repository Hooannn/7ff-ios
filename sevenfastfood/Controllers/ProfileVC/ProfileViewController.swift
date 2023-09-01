//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class ProfileViewController: ViewControllerWithoutNavigationBar {
    private let widgets = Widgets.shared
    private let viewModel = ProfileViewModel()
    private lazy var signOutButton: UIButton = {
        let button = widgets.createSecondaryButton(title: "Sign out", target: self, action: #selector(didTapSignOutButton))
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubviews(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func didTapSignOutButton() {
        let signOutAlertVC = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let acceptAction = UIAlertAction(title: "Confirm", style: .destructive) {
            _ in self.doSignOut()
        }
        signOutAlertVC.addAction(cancelAction)
        signOutAlertVC.addAction(acceptAction)
        present(signOutAlertVC, animated: true)
    }
    
    func doSignOut() {
        viewModel.performSignOut {
            self.changeScene(to: .auth)
        }
    }
}
