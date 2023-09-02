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
    private var user: User?
    {
        didSet {
            if let avatar = user?.avatar {
                avatarView.avatar = avatar
            }
            if let firstName = user?.firstName, let lastName = user?.lastName {
                avatarView.displayName = "\(firstName) \(lastName)"
            }
        }
    }
    
    private lazy var avatarView: ProfileAvatarView = {
        let view = ProfileAvatarView()
        return view
    }()
    
    private lazy var tableView: ProfileTableView = {
        let table = ProfileTableView(frame: .zero, style: .insetGrouped)
        return table
    }()

    private lazy var signOutButton: UIButton = {
        let button = widgets.createDangerButton(outline: true, title: "Sign out", target: self, action: #selector(didTapSignOutButton))
        return button
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, tableView, signOutButton])
        stack.spacing = 12
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUser()
        setupViews()
        setupConstraints()
    }
    
    func setupUser() {
        viewModel.getUser {
            user in self.user = user
        }
    }
    
    func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        title = "Profile"
        scrollView.addSubview(contentStackView)
        view.addSubview(scrollView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            avatarView.heightAnchor.constraint(equalToConstant: 140),
            tableView.heightAnchor.constraint(equalToConstant: 800),
            signOutButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight),
            signOutButton.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor, constant: 16),
            signOutButton.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor, constant: -16)
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
