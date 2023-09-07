//
//  CheckoutViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 06/09/2023.
//

import UIKit

protocol CheckoutViewModelDelegate: AnyObject {
    func didVerifyVoucherSuccess(_ voucher: Voucher?)
    func didVerifyVoucherFailure(_ error: Error)
    func didCheckoutSuccess(_ order: CreatedOrder?)
    func didCheckoutFailure(_ error: Error)
}

final class CheckoutViewModel {
    weak var delegate: CheckoutViewModelDelegate?
    
    init(delegate: CheckoutViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func verifyVoucherByCode(code: String) {
        VouchersService.shared.verify(withCode: code) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.didVerifyVoucherSuccess(data?.data)
            case .failure(let error):
                self.delegate?.didVerifyVoucherFailure(error)
            }
        }
    }
    
    func doCheckout(with form: CheckoutForm) {
        CheckoutService.shared.checkout(with: form) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.didCheckoutSuccess(data?.data)
            case .failure(let error):
                self.delegate?.didCheckoutFailure(error)
            }
        }
    }
    
    func getOrder(with id: String) {
        
    }
}
