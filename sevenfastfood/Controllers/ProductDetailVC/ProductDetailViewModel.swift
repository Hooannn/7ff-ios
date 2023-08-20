//
//  ProductDetailVIewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 20/08/2023.
//

import Foundation

protocol ProductDetailViewModelDelegate: AnyObject {
    func didFetchedProductDetailSuccess(_ product: Product?)
    func didFetchedProductDetailFailure(_ error: Error)
}

final class ProductDetailViewModel {
    weak var delegate: ProductDetailViewModelDelegate!
    private let productsService: ProductsService = ProductsService()
    
    
    func fetchProductDetail(withId id: String) {
        productsService.fetchDetailProduct(withId: id) {
            result in
            switch result {
            case .success(let data):
                self.delegate.didFetchedProductDetailSuccess(data?.data)
            case .failure(let error):
                self.delegate.didFetchedProductDetailFailure(error)
            }
        }
    }
}
