//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?)
}

final class CartViewModel {
    weak var delegate: CartViewModelDelegate?
    
    init(delegate: CartViewModelDelegate? = nil) {
        self.delegate = delegate
        setupNotificationCenter()
        self.didReceiveCartUpdateNotification()
    }
    
    deinit {
        removeNotificationCenter()
    }
    
    private func setupNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveCartUpdateNotification(_:)), name: NSNotification.Name.didSaveCart, object: nil)
    }
    
    private func removeNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.didSaveCart, object: nil)
    }
    
    private func didReceiveCartUpdateNotification() {
        let cartItems = LocalData.shared.getUserCart()
        delegate?.didReceiveCartUpdate(cartItems)
    }
    
    @objc func didReceiveCartUpdateNotification(_ notification: NSNotification) {
        let cartItems = LocalData.shared.getUserCart()
        delegate?.didReceiveCartUpdate(cartItems)
    }
}
