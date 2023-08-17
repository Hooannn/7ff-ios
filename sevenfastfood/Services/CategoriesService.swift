//
//  CategoriesService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 16/08/2023.
//

import Foundation
import Alamofire
final class CategoriesService {
    private var apiClient = APIClient.shared
    private var localDataClient = LocalData.shared

    public func fetchCategories(completion: @escaping (Result<Response<[Category]>?, Error>) -> Void) {
        apiClient.performGet(withResponseType: Response<[Category]>.self, withSubpath: "/categories", withParams: nil, completion: completion)
    }
}
