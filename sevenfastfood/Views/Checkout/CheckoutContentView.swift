//
//  CheckoutContentView.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit
class CheckoutContentView: BaseView {
    private let identifier = "OrderItem"
    private var orderItemsCollectionViewHeightConstraint: NSLayoutConstraint?
    var items: [CartItem]?
    
    convenience init(items: [CartItem]? = nil, delegate: (CheckoutVoucherViewDelegate & CheckoutInformationViewDelegate)? = nil) {
        self.init(frame: .zero)
        self.items = items
        voucherView.delegate = delegate
        informationView.delegate = delegate
    }
    
    private lazy var orderItemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CheckoutItemViewCell.self, forCellWithReuseIdentifier: identifier)
        return view
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Tokens.shared.secondaryColor
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    lazy var voucherView: CheckoutVoucherView = {
        let view = CheckoutVoucherView()
        return view
    }()
    
    lazy var informationView: CheckoutInformationView = {
        let view = CheckoutInformationView()
        return view
    }()
    
    lazy var paymentDetailsView: CheckoutPaymentDetailsView = {
        let view = CheckoutPaymentDetailsView()
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [orderItemsCollectionView, dividerView, voucherView, informationView, paymentDetailsView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private func reloadCollectionView() {
        orderItemsCollectionView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { _ in
            self.orderItemsCollectionViewHeightConstraint?.constant = self.orderItemsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.layoutIfNeeded()
        })
    }
    
    override func setupViews() {
        [informationView, voucherView, paymentDetailsView].forEach({
            view in
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            view.layer.borderColor = Tokens.shared.secondaryColor.cgColor
            view.layer.borderWidth = 0.2
        })
        addSubviews(contentStackView)
        reloadCollectionView()
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentStackView.widthAnchor.constraint(equalTo: widthAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor)
        ])
        orderItemsCollectionViewHeightConstraint = orderItemsCollectionView.heightAnchor.constraint(equalToConstant: orderItemsCollectionView.collectionViewLayout.collectionViewContentSize.height)
        orderItemsCollectionViewHeightConstraint?.isActive = true
        
        [informationView, paymentDetailsView].forEach {
            view in
            view.heightAnchor.constraint(equalToConstant: 150).isActive = true
            view.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        }
        voucherView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight).isActive = true
        voucherView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

extension CheckoutContentView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CheckoutItemViewCell
        let item = items?[indexPath.item]
        cell.featuredImage = item?.product.featuredImages?.first
        cell.name = item?.product.name.en
        cell.unitPrice = item?.product.price
        cell.category = item?.product.category?.name.en
        cell.quantity = item?.quantity ?? 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(bounds.width)
        let height = CGFloat(114)
        return CGSizeMake(width, height)
    }
}
