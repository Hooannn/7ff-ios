//
//  ProductDetailViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import UIKit
final class ProductDetailViewController: ViewControllerWithoutNavigationBar {
    private lazy var safeAreaInsets = UIApplication.shared.keyWindow?.rootViewController?.view.safeAreaInsets
    private lazy var viewModel: ProductDetailViewModel = {
        let viewModel = ProductDetailViewModel()
        viewModel.delegate = self
        return viewModel
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.zPosition = 10
        button.backgroundColor = .systemGray6
        button.tintColor = Tokens.shared.secondaryColor
        button.layer.borderColor = CGColor(gray: 40, alpha: 1)
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var productId: String = ""

    init(productId: String) {
        super.init(nibName: nil, bundle: nil)
        navigationItem.hidesBackButton = true
        self.productId = productId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLoading()
        setupViews()
        setupConstraints()
    }
    
    private func setupLoading() {
        view.addSubview(loadingIndicator)
        if productId != "" {
            loadingIndicator.startAnimating()
            viewModel.fetchProductDetail(withId: productId)
        }
        view.bringSubviewToFront(backButton)
    }
    
    private func removeLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.removeFromSuperview()
        }
    }
    
    private func setupViews() {
        view.addSubview(backButton)
    }
    
    private func setupProductViews(withProduct product: Product?) {
        removeLoading()
        let productDetailView = ProductDetailView(product: product, topConstant: CGFloat(safeAreaInsets!.top + 50))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.addSubview(productDetailView)
            NSLayoutConstraint.activate([
                productDetailView.topAnchor.constraint(equalTo: self.view.topAnchor),
                productDetailView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                productDetailView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                productDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
            self.view.layoutIfNeeded()
            self.view.bringSubviewToFront(self.backButton)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: view.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: safeAreaInsets!.top),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        view.layoutIfNeeded()
    }
    
    @objc func didTapBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func didFetchedProductDetailFailure(_ error: Error) {
        Toast.shared.display(with: "Fetched product detail error: \(error.localizedDescription)")
    }
    
    func didFetchedProductDetailSuccess(_ product: Response<Product>?) {
        setupProductViews(withProduct: product?.data)
    }
}
