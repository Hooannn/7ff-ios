//
//  HomeViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import UIKit

final class OnboardingViewController: UIViewController {
    let viewModel = OnboardingViewModel()
    private let tokens = Tokens.shared
    private let widgets = Widgets.shared
    private let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    private var viewControllers: [UIViewController]? = nil
    private var safeAreaInsets: UIEdgeInsets? = nil
    private var skipButton: UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
        setupPages()
    }
    private func createSkipButton() -> Void {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapSkipButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 1
        
        skipButton = button
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
    
    @objc func didTapSkipButton() {
        let signInVC = SignInViewController()
        signInVC.delegate = self
        signInVC.modalPresentationStyle = .automatic
        navigationController?.present(signInVC, animated: true)
    }
    
    @objc func didTapContinueButton() {
        print("didTabContinueButton")
    }
    
    @objc func didTapStartedButton() {
        let signUpVC = SignUpViewController()
        signUpVC.delegate = self
        signUpVC.modalPresentationStyle = .automatic
        navigationController?.present(signUpVC, animated: true)
    }
    
    private func setupPages() {
        createSkipButton()
        pageVC.dataSource = self
        let onboardingScreens = viewModel.fetchOnboardingScreens()
        
        viewControllers = onboardingScreens.compactMap( {
            onboardingScreen in
            let vc = UIViewController()
            vc.view.backgroundColor = Tokens.shared.secondaryColor
            setupOnboardingView(for: vc, title: onboardingScreen.title, description: onboardingScreen.description, displayImage: onboardingScreen.displayImage!, buttonTitle: onboardingScreen.buttonTitle, isFinal: onboardingScreen.isFinal)
            return vc
        } )
        
        let initViewController = viewControllers!.first!
        pageVC.setViewControllers([initViewController], direction: .forward, animated: true)
        addChild(pageVC)
        view.addSubview(pageVC.view)
        pageVC.didMove(toParent: self)
    }
    
    private func setupOnboardingView(for vc: UIViewController, title _title: String, description _description: String, displayImage image: UIImage, buttonTitle _buttonTitle: String, isFinal _isFinal: Bool) {
        let topView = {
           let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()

        let bottomView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .white
            view.layer.cornerRadius = CGFloat(24)
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return view
        }()

        let imageView = {
            let view = UIImageView(image: image)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.contentMode = .scaleAspectFit
            view.clipsToBounds = true
            return view
        }()

        let titleLabel = {
            let label = UILabel()
            label.text = _title
            label.numberOfLines = 0
            label.textColor = tokens.secondaryColor
            label.font = UIFont.boldSystemFont(ofSize: tokens.titleFontSize)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        let descriptionLabel = {
            let label = UILabel()
            label.text = _description
            label.numberOfLines = 0
            label.textColor = .gray
            label.textAlignment = .center
            label.font.withSize(tokens.descriptionFontSize)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let action: Selector = _isFinal ? #selector(didTapStartedButton) : #selector(didTapContinueButton)
        let actionButton = widgets.createSecondaryButton(title: _buttonTitle, target: self, action: action)

        vc.view.addSubviews(topView, bottomView)
        topView.addSubviews(imageView)
        bottomView.addSubviews(titleLabel, descriptionLabel, actionButton)

        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: safeAreaInsets!.top),
            topView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor),
            topView.heightAnchor.constraint(equalTo: vc.view.heightAnchor, multiplier: 0.52),
            
            imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            imageView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.7),

            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            bottomView.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            bottomView.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 48),
            titleLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.7),
            
            actionButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -(safeAreaInsets!.bottom + 24)),
            actionButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.7),
            actionButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            descriptionLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: vc.view.widthAnchor, multiplier: 0.7),
        ])
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers?.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        if nextIndex >= viewControllers!.count {
            return nil
        }
        
        return viewControllers![nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers?.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        if previousIndex < 0 {
            return nil
        }
        
        return viewControllers![previousIndex]
    }
}


extension OnboardingViewController: SignUpViewControllerDelegate, SignInViewControllerDelegate {
    func didTapAlreadyHaveAccountButton() {
        didTapSkipButton()
    }
    
    func didTapDoNotHaveAnAccountYetButton() {
        didTapStartedButton()
    }
}
