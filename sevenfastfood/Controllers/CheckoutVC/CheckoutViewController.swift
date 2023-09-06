//
//  CheckoutViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit
final class CheckoutViewController: UIViewController {
    private lazy var safeAreaInsets = Tokens.shared.safeAreaInsets
    
    private lazy var profileViewModel: ProfileViewModel = {
       ProfileViewModel()
    }()
    
    private var cartItems: [CartItem] = []
    private var subtotal: Double?
    {
        didSet {
            checkoutContentView.paymentDetailsView.subtotal = subtotal
            calculateTotalPrice()
        }
    }
    private var shippingFee: Double?
    {
        didSet {
            checkoutContentView.paymentDetailsView.shippingFee = shippingFee
            calculateTotalPrice()
        }
    }
    private var discount: Double?
    {
        didSet {
            checkoutContentView.paymentDetailsView.discount = discount
            calculateTotalPrice()
        }
    }
    private var totalPrice: Double?
    {
        didSet {
            checkoutContentView.paymentDetailsView.totalPrice = totalPrice
            checkoutFooterView.totalPrice = totalPrice
        }
    }
    
    convenience init(cartItems: [CartItem], subtotal: Double) {
        self.init(nibName: nil, bundle: nil)
        self.cartItems = cartItems
        self.subtotal = subtotal
        self.shippingFee = subtotal >= CartDiscountProgressView.MINIMUM_VALUE_FOR_FREE_SHIPPING ? 0 : CartDiscountProgressView.DEFAULT_SHIPPING_FEE
        self.discount = 0
        checkoutContentView.paymentDetailsView.subtotal = self.subtotal
        checkoutContentView.paymentDetailsView.shippingFee = self.shippingFee
        checkoutContentView.paymentDetailsView.discount = self.discount
        
        calculateTotalPrice()
        
        profileViewModel.getUser {
            user in
            self.checkoutContentView.informationView.name = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            self.checkoutContentView.informationView.address = "\(user?.address ?? "Not updated yet")"
            self.checkoutContentView.informationView.phoneNumber = "\(user?.phoneNumber ?? "Not updated yet")"
        }
    }
    
    private lazy var checkoutContentView: CheckoutContentView = {
        let view = CheckoutContentView(items: cartItems)
        return view
    }()
    
    private lazy var checkoutFooterView: CheckoutFooterView = {
        let view = CheckoutFooterView()
        view.delegate = self
        view.backgroundColor = .white
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowColor = UIColor.systemGray.cgColor
        view.layer.shadowOpacity = Float(0.3)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        return view
    }()
    
    private func calculateTotalPrice() {
        totalPrice = (subtotal ?? 0) + (shippingFee ?? 0) - (discount ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        title = "Checkout"
        scrollView.addSubview(checkoutContentView)
        view.addSubviews(scrollView, checkoutFooterView)
        view.backgroundColor = Tokens.shared.lightBackgroundColor
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkoutFooterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            checkoutFooterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            checkoutFooterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            checkoutFooterView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight + 12 + 24 + (safeAreaInsets?.bottom ?? 0)),
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Tokens.shared.containerXPadding),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            scrollView.bottomAnchor.constraint(equalTo: checkoutFooterView.topAnchor),
            
            checkoutContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            checkoutContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            checkoutContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

extension CheckoutViewController: CheckoutFooterDelegate {
    func didTapSubmitButton(_ sender: UIButton) {
        debugPrint("submit")
    }
}
