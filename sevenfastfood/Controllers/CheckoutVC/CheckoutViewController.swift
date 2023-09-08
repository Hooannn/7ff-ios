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
    
    private lazy var cartViewModel: CartViewModel = {
        CartViewModel()
    }()
    
    private lazy var myOrdersViewModel: MyOrdersViewModel = {
        MyOrdersViewModel()
    }()
    
    private var user: User?
    private lazy var viewModel: CheckoutViewModel = {
        CheckoutViewModel(delegate: self)
    }()

    private var deliveryPhone: String?
    {
        didSet {
            guard let deliveryPhone = deliveryPhone else { return }
            self.checkoutContentView.informationView.phoneNumber = deliveryPhone
        }
    }
    
    private var deliveryAddress: String?
    {
        didSet {
            guard let deliveryAddress = deliveryAddress else { return }
            self.checkoutContentView.informationView.address = deliveryAddress
        }
    }
    
    private var cartItems: [CartItem] = []
    private var voucher: String?
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
            self.user = user
            self.checkoutContentView.informationView.name = "\(user?.firstName ?? "") \(user?.lastName ?? "")"
            self.checkoutContentView.informationView.address = "\(user?.address ?? "Not updated yet")"
            self.checkoutContentView.informationView.phoneNumber = "\(user?.phoneNumber ?? "Not updated yet")"
            self.deliveryAddress = user?.address
            self.deliveryPhone = user?.phoneNumber
        }
    }
    
    private lazy var checkoutContentView: CheckoutContentView = {
        let view = CheckoutContentView(items: cartItems, delegate: self)
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

extension CheckoutViewController: EditOrderInformationViewControllerDelegate {
    func didSave(_ sender: UIBarButtonItem, _ address: String, _ phone: String) {
        deliveryAddress = address
        deliveryPhone = phone
    }
}

extension CheckoutViewController: CheckoutFooterViewDelegate, CheckoutVoucherViewDelegate, CheckoutInformationViewDelegate {
    func didTapSubmitButton(_ sender: UIButton) {
        if deliveryPhone == nil || deliveryAddress == nil {
            didTapEditButton(sender)
            return
        }
        guard let customerId = user?._id else { return }
        let checkoutItems = cartItems.compactMap {
            cartItem in
            CheckoutItem(product: cartItem.product._id!, quantity: cartItem.quantity)
        }
        let form = CheckoutForm(customerId: customerId, isDelivery: true, items: checkoutItems, deliveryPhone: "\(deliveryPhone ?? "")", deliveryAddress: deliveryAddress, voucher: voucher, note: nil)
        checkoutFooterView.setLoading(isLoading: true)
        viewModel.doCheckout(with: form)
    }
    
    func didTapEditButton(_ sender: UIButton) {
        let editVC = EditOrderInformationViewController(address: deliveryAddress, phone: deliveryPhone)
        editVC.delegate = self
        let navigation = UINavigationController(rootViewController: editVC)
        navigation.modalPresentationStyle = .automatic
        present(navigation, animated: true)
    }
    
    func didTapCancelButton(_ sender: UIButton, _ voucherTextField: UITextField) {
        checkoutContentView.voucherView.setState(state: .empty)
        self.discount = 0
        self.voucher = nil
    }
    
    func didTapApplyButton(_ sender: UIButton,_ voucherTextField: UITextField) {
        if voucherTextField.hasText, let code = voucherTextField.text {
            checkoutContentView.voucherView.setLoading(isLoading: true)
            viewModel.verifyVoucherByCode(code: code)
        } else {
            Toast.shared.display(with: "Voucher must not be empty")
        }
    }
}

extension CheckoutViewController: CheckoutViewModelDelegate {
    func didVerifyVoucherSuccess(_ voucher: Voucher?) {
        Toast.shared.display(with: "Applied voucher")
        checkoutContentView.voucherView.setLoading(isLoading: false)
        checkoutContentView.voucherView.setState(state: .applying)
        let discountType = voucher?.discountType
        let discountAmount = voucher?.discountAmount
        self.voucher = voucher?._id
        switch discountType {
        case .amount:
            self.discount = discountAmount
        case .percent:
            self.discount = (self.subtotal ?? 0) * (discountAmount ?? 0)
        default:
            break
        }
    }
    
    func didVerifyVoucherFailure(_ error: Error) {
        checkoutContentView.voucherView.setLoading(isLoading: false)
        checkoutContentView.voucherView.setState(state: .empty)
        Toast.shared.display(with: "Verify voucher error: \(error.localizedDescription)")
    }
    
    func didCheckoutSuccess(_ order: CreatedOrder?) {
        cartViewModel.fetchCartItems()
        myOrdersViewModel.fetchOrders()
        checkoutFooterView.setLoading(isLoading: false)
        let orderId = order?._id ?? "None"
        let successVC = CheckoutSuccessViewController(orderId: orderId)
        self.pushViewControllerWithoutBottomBar(successVC)
    }
    
    func didCheckoutFailure(_ error: Error) {
        checkoutFooterView.setLoading(isLoading: false)
        Toast.shared.display(with: "Submit error due to \(error.localizedDescription)")
    }
}
