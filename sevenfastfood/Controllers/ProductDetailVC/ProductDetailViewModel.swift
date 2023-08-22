//
//  ProductDetailVIewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import Foundation

protocol ProductDetailViewModelDelegate: AnyObject {
    func didFetchProductDetailSuccess(_ product: Product?)
    func didFetchProductDetailFailure(_ error: Error)
}

final class ProductDetailViewModel {
    weak var delegate: ProductDetailViewModelDelegate!
    
    func fetchProductDetail(withId id: String) {
        ProductsService.shared.fetchDetailProduct(withId: id) {
            result in
            switch result {
            case .success(let data):
                self.delegate.didFetchProductDetailSuccess(data?.data)
            case .failure(let error):
                self.delegate.didFetchProductDetailFailure(error)
            }
        }
    }
}
