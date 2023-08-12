//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class SignUpViewController: UIViewController {
    private let tokens = Tokens.shared
    private let widgets = Widgets.shared
    private var topView: UIView!
    private var screenTitleLabel: UILabel!
    private var separatorView: UIView!
    private var bottomView: UIView!
    private var headerView: UIView!
    private var closeButton: UIButton!
    private var formView: SignUpFormView!
    private var googleAuthButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Sign up"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        
        headerView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        topView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        separatorView = {
            let view = UIView()
            view.backgroundColor = .systemGray2
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        bottomView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        screenTitleLabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Create an account"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: tokens.titleFontSize)
            return label
        }()
        
        formView = SignUpFormView(textFieldDelegate: self)
        formView.delegate = self
        
        closeButton = {
            let button = UIButton(type: .close)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
            return button
        }()
        
        googleAuthButton = widgets.createGoogleAuthButton(title: "Continue with Google", target: self, action: #selector(didTapGoogleAuthButton))
        view.addSubviews(headerView, topView, separatorView, bottomView)
        headerView.addSubviews(closeButton)
        topView.addSubviews(screenTitleLabel, formView)
        bottomView.addSubviews(googleAuthButton)
    }
    
    private func setupConstraints() {
        // Constraint for main view
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            topView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.55),
            
            separatorView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            screenTitleLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.7),
            screenTitleLabel.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            screenTitleLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            screenTitleLabel.heightAnchor.constraint(equalToConstant: 80),
            
            formView.topAnchor.constraint(equalTo: screenTitleLabel.bottomAnchor),
            formView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 24),
            formView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -24),
            formView.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
            
            googleAuthButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 24),
            googleAuthButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24),
            googleAuthButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            googleAuthButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)
        ])
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapGoogleAuthButton() {
        print("tapped google Auth")
    }
}



extension SignUpViewController: UITextFieldDelegate, SignUpFormViewDelegate {
    func didTapCreateAccountButton(form _form: SignUpForm) {
        print("Create Account \(_form)")
    }
    
    func didTapAlreadyHaveAccountButton() {
        print("Already have account")
    }
    
    func didValidateFailed(messages _messages: [String]) {
        if let rootWindow = UIApplication.shared.windows.first {
            rootWindow.displayToast(with: "\(_messages)")
        }
    }
}
