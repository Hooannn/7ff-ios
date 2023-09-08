//
//  MyOrdersViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 03/09/2023.
//

import Foundation

protocol MyOrdersViewModelDelegate: AnyObject {
    func didReceiveOrdersUpdate(_ orders: [Order]?)
}

final class MyOrdersViewModel {
    weak var delegate: MyOrdersViewModelDelegate?
    
    init(delegate: MyOrdersViewModelDelegate? = nil) {
        self.delegate = delegate
        if delegate != nil {
            setupNotifications()
        }
        self.didReceiveOrdersUpdateNotification()
    }
    
    deinit {
        if delegate != nil {
            removeNotifications()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveOrdersUpdateNotification(_:)), name: NSNotification.Name.didSaveOrders, object: nil)
    }
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didSaveOrders, object: nil)
    }
    
    private func didReceiveOrdersUpdateNotification() {
        let orders = LocalData.shared.getOrders()
        delegate?.didReceiveOrdersUpdate(orders)
    }
    
    func fetchOrders() {
        OrdersService.shared.fetch()
    }
    
    @objc func didReceiveOrdersUpdateNotification(_ notification: NSNotification) {
        let orders = LocalData.shared.getOrders()
        delegate?.didReceiveOrdersUpdate(orders)
    }
}
