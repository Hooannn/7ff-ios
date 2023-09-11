//
//  OrderDetailViewController.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 10/09/2023.
//

import UIKit
import Cosmos

final class OrderDetailViewController: UIViewController {
    private var orderId: String?
    private lazy var viewModel: OrderDetailViewModel = {
        OrderDetailViewModel(delegate: self)
    }()
    
    private lazy var ratingAlertController: UIAlertController = {
        var rating: Double = 3.0
        let ratingView: CosmosView = {
            let view = CosmosView()
            view.rating = rating
            view.translatesAutoresizingMaskIntoConstraints = false
            view.settings.fillMode = .full
            view.settings.starMargin = 5
            view.settings.starSize = 18
            return view
        }()
        let alertVC = UIAlertController(title: "Rate us", message: "    ", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let acceptAction = UIAlertAction(title: "Confirm", style: .default) {
            _ in
            if let orderId = self.orderId {
                self.viewModel.ratingOrder(with: orderId, value: rating)
            }
        }
        
        alertVC.view.addSubview(ratingView)
        alertVC.addAction(cancelAction)
        alertVC.addAction(acceptAction)
        NSLayoutConstraint.activate([
            ratingView.centerXAnchor.constraint(equalTo: alertVC.view.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: alertVC.view.centerYAnchor),
        ])
        ratingView.didFinishTouchingCosmos = {
            value in
            rating = value
        }
        
        return alertVC
    }()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var contentScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        return view
    }()
    
    var contentStackView: UIStackView?
    
    private lazy var headerView: OrderDetailsHeaderView = {
        let view = OrderDetailsHeaderView()
        return view
    }()
    
    private lazy var ratingView: OrderDetailsRatingView = {
        let view = OrderDetailsRatingView()
        return view
    }()
    
    private lazy var detailsView: OrderDetailsDetailsView = {
        let view = OrderDetailsDetailsView()
        return view
    }()
    
    private lazy var itemsView: OrderDetailsItemsView = {
        let view = OrderDetailsItemsView()
        return view
    }()
    
    private lazy var footerView: OrderDetailsFooterView = {
        let view = OrderDetailsFooterView()
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        guard let orderId = self.orderId else { return }
        loadingView.startAnimating()
        viewModel.fetchOrderDetail(with: orderId)
    }
    
    convenience init(orderId: String) {
        self.init(nibName: nil, bundle: nil)
        self.orderId = orderId
    }
    
    private func setupViews() {
        view.backgroundColor = Tokens.shared.lightBackgroundColor
        view.addSubviews(loadingView, contentScrollView, footerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            loadingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.heightAnchor.constraint(equalToConstant: Tokens.shared.defaultButtonHeight + 12 + (Tokens.shared.safeAreaInsets?.bottom ?? 0)),
            
            contentScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Tokens.shared.containerXPadding),
            contentScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Tokens.shared.containerXPadding),
            contentScrollView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 72),
            ratingView.heightAnchor.constraint(equalToConstant: 72)
        ])
    }
    
    private func addContentStackView(haveRated: Bool, rating: Double? = nil) {
        contentStackView?.removeFromSuperview()
        ratingView.rating = rating
        let subviews = haveRated ? [headerView, ratingView, detailsView, itemsView] : [headerView, detailsView, itemsView]
        let view = UIStackView(arrangedSubviews: subviews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 12
        self.contentStackView = view
        contentScrollView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentScrollView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentScrollView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentScrollView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentScrollView.bottomAnchor),
            view.widthAnchor.constraint(equalTo: contentScrollView.widthAnchor),
        ])
    }
}

extension OrderDetailViewController: OrderDetailViewModelDelegate {
    func didFetchOrderDetailFailure(_ error: Error) {
        loadingView.stopAnimating()
        Toast.shared.display(with: "Error when fetching order details: \(error.localizedDescription)")
    }
    
    func didFetchOrderDetailSuccess(_ order: Order?) {
        loadingView.stopAnimating()
        contentScrollView.isHidden = false
        footerView.isHidden = false
        
        if order?.rating == nil {
            addContentStackView(haveRated: false)
        } else {
            addContentStackView(haveRated: true, rating: order?.rating)
        }
        
        if let status = order?.status, let orderId = order?._id {
            headerView.setData(orderStatus: status, orderId: orderId)
        }
        if let items = order?.items {
            itemsView.items = items
        }
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]
        if let placedAt = order?.createdAt {
            if let date = isoDateFormatter.date(from: placedAt) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy HH:mm"
                let formattedDateString = dateFormatter.string(from: date)
                detailsView.data[0] = formattedDateString
            }
        }
        if let updatedAt = order?.updatedAt {
            if let date = isoDateFormatter.date(from: updatedAt) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy HH:mm"
                let formattedDateString = dateFormatter.string(from: date)
                detailsView.data[1] = formattedDateString
            }
        }
        if let total = order?.totalPrice {
            let formatter = NumberFormatter()
            formatter.locale = Locale.init(identifier: "vi_VN")
            formatter.numberStyle = .currency
            if let formattedTotalPrice = formatter.string(from: (total) as NSNumber) {
                detailsView.data[2] = formattedTotalPrice
            }
        }
        if let address = order?.deliveryAddress {
            detailsView.data[3] = address
        }
        if let phone = order?.deliveryPhone {
            detailsView.data[4] = phone
        }
        detailsView.tableView.reloadData()
        
        if let status = order?.status, status == .Done {
            let rating = order?.rating
            if rating == nil {
                footerView.showRateButton()
            } else {
                footerView.showContactButton()
            }
        }
    }
    
    func didRateOrderDetailFailure(_ error: Error) {
        Toast.shared.display(with: "Failed to rate order due to: \(error.localizedDescription)")
    }
    
    func didRateOrderDetailSuccess(_ order: CreatedOrder?) {
        ratingAlertController.dismiss(animated: true) {
            Toast.shared.display(with: "Thanks for your rating!")
            if let orderId = self.orderId {
                self.loadingView.startAnimating()
                self.viewModel.fetchOrderDetail(with: orderId)
            }
        }
    }
}

extension OrderDetailViewController: OrderDetailsFooterViewDelegate {
    func didTapRateButton(_ sender: UIButton) {
        present(ratingAlertController, animated: true)
    }
}
