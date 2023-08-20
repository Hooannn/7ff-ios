//
//  ProductsService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 18/08/2023.
//

import Foundation
import Alamofire
final class ProductsService {
    private var apiClient = APIClient.shared
    private var localDataClient = LocalData.shared

    public func fetchProducts(withParams params: Parameters?, completion: @escaping (Result<Response<[Product]>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<[Product]>.self, withSubpath: "/products", withParams: params, completion: completion)
    }
    
    public func fetchDetailProduct(withId id: String, completion: @escaping (Result<Response<Product>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<Product>.self, withSubpath: "/products/\(id)", withParams: nil, completion: completion)
    }
}
