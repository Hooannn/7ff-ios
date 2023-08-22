//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation
import Alamofire

protocol HomeViewModelDelegate: AnyObject {
    func didFetchCategoriesSuccess(_ categories: [Category]?)
    func didFetchCategoriesFailure(_ error: Error)
    func didFetchProductsSuccess(_ products: [Product]?)
    func didFetchProductsFailure(_ error: Error)
}

final class HomeViewModel {
    weak var delegate: HomeViewModelDelegate!
    func fetchCategories() {
        CategoriesService.shared.fetchCategories {
            result in switch result {
            case.success(let data):
                self.delegate.didFetchCategoriesSuccess(data?.data)
            case.failure(let error):
                self.delegate.didFetchCategoriesFailure(error)
            }
        }
    }
    
    func fetchProducts(withParams params: Parameters?) {
        ProductsService.shared.fetchProducts(withParams: params) {
            result in switch result {
            case.success(let data):
                self.delegate.didFetchProductsSuccess(data?.data)
            case.failure(let error):
                self.delegate.didFetchProductsFailure(error)
            }
        }
    }
}
