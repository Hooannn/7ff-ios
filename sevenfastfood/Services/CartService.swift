//
//  CartService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 22/08/2023.
//

import Foundation
import Alamofire
final class CartService {
    private var apiClient = APIClient.shared
    static let shared = CartService()
    public func fetchItems(completion: @escaping (Result<Response<[CartItem]>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<[CartItem]>.self, withSubpath: "/users/cart", withParams: nil) {
            result in
            switch result {
            case .success(let data):
                LocalData.shared.saveUserCart(cartItems: data?.data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetchItems() {
        apiClient.performGet(withResponseType: Response<[CartItem]>.self, withSubpath: "/users/cart", withParams: nil) {
            result in
            switch result {
            case .success(let data):
                LocalData.shared.saveUserCart(cartItems: data?.data)
            case .failure(let error):
                debugPrint("Error when fetching items: \(error.localizedDescription)")
            }
        }
    }
    
    public func addItem(productId: String, quantity: Int, completion: @escaping (Result<Response<[CartItem]>?, Error>) -> Void) {
        let params = [
            "product": productId,
            "quantity": quantity
        ] as [String : Any]
        apiClient.performPatch(withResponseType: Response<[CartItem]>.self, withSubpath: "/users/cart/add", withParams: params) {
            result in
            switch result {
            case .success(let data):
                self.fetchItems()
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func removeItem(productId: String, quantity: Int, completion: @escaping (Result<Response<[CartItem]>?, Error>) -> Void) {
        let params = [
            "product": productId,
            "quantity": quantity
        ] as [String : Any]
        apiClient.performPatch(withResponseType: Response<[CartItem]>.self, withSubpath: "/users/cart/remove", withParams: nil) {
            result in
            switch result {
            case .success(let data):
                self.fetchItems()
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
