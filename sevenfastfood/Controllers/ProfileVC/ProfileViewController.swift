//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let widgets = Widgets.shared
    private let viewModel = ProfileViewModel()
    private lazy var signOutButton: UIButton = {
        let button = widgets.createSecondaryButton(title: "Sign out", target: self, action: #selector(didTapSignOutButton))
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        view.addSubviews(signOutButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            signOutButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            signOutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            signOutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    @objc func didTapSignOutButton() {
        let signOutAlertVC = UIAlertController(title: "Sign out", message: "Are you sure you want to sign out ?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
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
