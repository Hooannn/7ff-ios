//
//  OrdersService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 08/09/2023.
//

import Alamofire
final class OrdersService {
    private var apiClient = APIClient.shared
    static let shared = OrdersService()
    
    public func fetchDetail(withId id: String, completion: @escaping (Result<Response<Order>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<Order>.self, withSubpath: "/orders/\(id)?locale=en", withParams: nil, completion: completion)
    }
    
    public func fetch(with params: Parameters, completion: @escaping (Result<Response<[Order]>?, Error>) -> Void) {
        guard let userId = LocalData.shared.getLoggedUser()?._id else { completion(.failure(NSError(domain: "OrdersService.fetch", code: 122, userInfo: [NSLocalizedDescriptionKey: "No user id"])))
            return
        }
        apiClient.performGet(withResponseType: Response<[Order]>.self, withSubpath: "/my-orders/\(userId)?locale=en", withParams: params) {
            result in
            switch result {
            case .success(let data):
                LocalData.shared.saveOrders(orders: data?.data)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func fetch() {
        guard let userId = LocalData.shared.getLoggedUser()?._id else {
            return
        }
        apiClient.performGet(withResponseType: Response<[Order]>.self, withSubpath: "/my-orders/\(userId)?locale=en", withParams: nil) {
            result in
            switch result {
            case .success(let data):
                LocalData.shared.saveOrders(orders: data?.data)
            case .failure(let error):
                Toast.shared.display(with: "Error when fetching orders: \(error.localizedDescription)")
            }
        }
    }
    
    public func rating(withId id: String, value: Int, completion: @escaping (Result<Response<CreatedOrder>?, Error>) -> Void) {
        let params = [
            "value": value
        ]
        apiClient.performPut(withResponseType: Response<CreatedOrder>.self, withSubpath: "/rating/\(id)?locale=en", withParams: params, completion: completion)
    }
}

