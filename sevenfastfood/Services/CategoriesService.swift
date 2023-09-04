//
//  CategoriesService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import Alamofire
final class CategoriesService {
    private var apiClient = APIClient.shared
    private var localDataClient = LocalData.shared
    static let shared = CategoriesService()
    public func fetch(completion: @escaping (Result<Response<[Category]>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<[Category]>.self, withSubpath: "/categories", withParams: nil, completion: completion)
    }
}
