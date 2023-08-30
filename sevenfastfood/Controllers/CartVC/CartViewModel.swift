//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func didReceiveCartUpdate(_ cartItems: [CartItem]?)
    func didUpdateCartItemSuccess(_ productId: String,_ cartItems: [CartItem]?)
    func didUpdateCartItemFailure(_ productId: String,_ error: Error)
}

extension CartViewModelDelegate {
    func didUpdateCartItemSuccess(_ productId: String,_ cartItems: [CartItem]?) {}
    func didUpdateCartItemFailure(_ productId: String,_ error: Error) {}
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
    
    func updateCartItemQuantity(_ newValue: Int,_ productId: String) {
        let cartItems = LocalData.shared.getUserCart()
        guard let target = cartItems?.first(where: { cartItem in cartItem.product._id == productId }) else { return }
        let oldValue = target.quantity
        if oldValue == newValue {
            delegate?.didUpdateCartItemSuccess(productId, nil)
            return
        }
        if newValue > oldValue {
            let increasedQuantity = newValue - oldValue
            CartService.shared.addItem(productId: productId, quantity: increasedQuantity) {
                [weak self] result in switch result {
                case .success(let data):
                    self?.delegate?.didUpdateCartItemSuccess(productId, data?.data)
                case .failure(let error):
                    self?.delegate?.didUpdateCartItemFailure(productId, error)
                }
            }
        } else {
            let decreasedQuantity = oldValue - newValue
            CartService.shared.removeItem(productId: productId, quantity: decreasedQuantity) {
                [weak self] result in switch result {
                case .success(let data):
                    self?.delegate?.didUpdateCartItemSuccess(productId, data?.data)
                case .failure(let error):
                    self?.delegate?.didUpdateCartItemFailure(productId, error)
                }
            }
        }
    }
    
    @objc func didReceiveCartUpdateNotification(_ notification: NSNotification) {
        let cartItems = LocalData.shared.getUserCart()
        delegate?.didReceiveCartUpdate(cartItems)
    }
}
