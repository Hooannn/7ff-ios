//
//  OrderDetailViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 10/09/2023.
//

import Foundation

protocol OrderDetailViewModelDelegate: AnyObject {
    func didFetchOrderDetailSuccess(_ order: Order?)
    func didFetchOrderDetailFailure(_ error: Error)
    
    func didRateOrderDetailSuccess(_ order: CreatedOrder?)
    func didRateOrderDetailFailure(_ error: Error)
}

final class OrderDetailViewModel {
    weak var delegate: OrderDetailViewModelDelegate?
    
    init(delegate: OrderDetailViewModelDelegate? = nil) {
        self.delegate = delegate
    }
    
    func fetchOrderDetail(with id: String) {
        OrdersService.shared.fetchDetail(withId: id) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.didFetchOrderDetailSuccess(data?.data)
            case .failure(let error):
                self.delegate?.didFetchOrderDetailFailure(error)
            }
        }
    }
    
    func ratingOrder(with id: String, value: Double) {
        OrdersService.shared.rating(withId: id, value: Int(value)) {
            result in
            switch result {
            case .success(let data):
                self.delegate?.didRateOrderDetailSuccess(data?.data)
            case .failure(let error):
                self.delegate?.didRateOrderDetailFailure(error)
            }
        }
    }
}
