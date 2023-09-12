//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit
import Alamofire
import GoogleSignIn
protocol SignUpViewControllerDelegate: AnyObject {
    func didTapAlreadyHaveAccountButton()
}

final class SignUpViewController: KeyboardAvoidViewController {
    private let tokens = Tokens.shared
    private let widgets = Widgets.shared
    weak var delegate: SignUpViewControllerDelegate!
    
    private var originalContainerBottomConstraint: NSLayoutConstraint?
    private var keyboardContainerBottomConstraint: NSLayoutConstraint?
    
    override func keyboardWillHide(notification: NSNotification) {
        /*
        keyboardContainerBottomConstraint?.isActive = false
        originalContainerBottomConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        */
    }
    
    override func keyboardWillShow(notification: NSNotification) {
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardContainerBottomConstraint == nil {
                keyboardContainerBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height)
            }
            keyboardContainerBottomConstraint?.isActive = true
            originalContainerBottomConstraint?.isActive = false
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
        */
    }
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .close)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var formView: SignUpFormView = {
        let formView = SignUpFormView(textFieldDelegate: self)
        formView.delegate = self
        return formView
    }()
    
    private lazy var laterButton: UIButton = {
        let button = UIButton(type: .system)
        // Hide
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapLaterButton), for: .touchUpInside)
        button.setTitle("Later", for: .normal)
        button.tintColor = .systemGray
        return button
    }()
    
    private lazy var googleAuthButton: UIButton = {
        widgets.createGoogleAuthButton(title: "Continue with Google", target: self, action: #selector(didTapGoogleAuthButton))
    }()

    private lazy var viewModel: SignUpViewModel = {
        let viewModel = SignUpViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubviews(headerView, topView, separatorView, bottomView)
        headerView.addSubviews(closeButton, laterButton)
        topView.addSubviews(formView)
        bottomView.addSubviews(googleAuthButton)
    }
    
    private func setupConstraints() {
        // Constraint for main view
        originalContainerBottomConstraint = bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            topView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.65),
            
            separatorView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            
            bottomView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            originalContainerBottomConstraint!
        ])
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            laterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -24),
            laterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            formView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 24),
            formView.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 24),
            formView.trailingAnchor.constraint(equalTo: topView.trailingAnchor, constant: -24),
            formView.bottomAnchor.constraint(equalTo: separatorView.topAnchor, constant: -24),
            
            googleAuthButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 24),
            googleAuthButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24),
            googleAuthButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            googleAuthButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            googleAuthButton.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight)
        ])
    }
    
    @objc func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTapGoogleAuthButton() {
        let root = UIApplication.shared.keyWindow?.rootViewController
        GIDSignIn.sharedInstance.signIn(withPresenting: root!) {
            result, error in
            if error == nil {
                guard let googleAccessToken = result?.user.accessToken else {
                    Toast.shared.display(with: "Missing google access token")
                    return
                }
                self.viewModel.performGoogleAuthentication(with: googleAccessToken.tokenString)
                return
            }
            Toast.shared.display(with: error?.localizedDescription)
        }
    }
    
    @objc func didTapLaterButton() {
        changeScene(to: .main)
    }
}



extension SignUpViewController: UITextFieldDelegate, SignUpFormViewDelegate {
    func didTapCreateAccountButton(form _form: SignUpForm) {
        viewModel.performSignUp(with: _form)
    }
    func didTapAlreadyHaveAccountButton() {
        dismiss(animated: true) {
            self.delegate.didTapAlreadyHaveAccountButton()
        }
    }
    func didValidateFailed(messages _messages: [String]) {
        Toast.shared.display(with: _messages.first)
    }
}

extension SignUpViewController: SignUpViewModelDelegate {
    func didSignUpSuccess(with data: Response<SignInResponseData>?) {
        Toast.shared.display(with: data?.message ?? "Success")
        changeScene(to: .main)
    }
    func didSignUpFailure(with error: Error?) {
        Toast.shared.display(with: error?.localizedDescription)
    }
    func didUpdateLoading(_ isLoading: Bool) {
        formView.setLoading(isLoading)
    }
}
