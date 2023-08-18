//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didFetchedCategoriesSuccess(_ categories: [Category]?)
    func didFetchedCategoriesFailure(_ error: Error)
    func didFetchedProductsSuccess(_ products: [Product]?)
    func didFetchedProductsFailure(_ error: Error)
}

final class HomeViewModel {
    private let categoriesService = CategoriesService()
    private let productsService = ProductsService()
    weak var delegate: HomeViewModelDelegate!
    func fetchCategories() {
        categoriesService.fetchCategories {
            result in switch result {
            case.success(let data):
                self.delegate.didFetchedCategoriesSuccess(data?.data)
            case.failure(let error):
                self.delegate.didFetchedCategoriesFailure(error)
            }
        }
    }
    
    func fetchProducts() {
        productsService.fetchProducts {
            result in switch result {
            case.success(let data):
                self.delegate.didFetchedProductsSuccess(data?.data)
            case.failure(let error):
                self.delegate.didFetchedProductsFailure(error)
            }
        }
    }
}
