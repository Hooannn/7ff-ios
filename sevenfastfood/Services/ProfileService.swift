//
//  UserService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 03/09/2023.
//

import Alamofire
final class ProfileService {
    private var apiClient = APIClient.shared
    static let shared = ProfileService()

    public func update(withParams params: Parameters?, completion: @escaping (Result<Response<User>?, Error>) -> Void) {
        apiClient.performPatch(withResponseType: Response<User>.self, withSubpath: "/users/profile", withParams: params) {
            result in
            switch result {
            case .success(let data):
                guard let user = data?.data else { return }
                LocalData.shared.setLoggedUser(user)
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func changePassword(newPassword: String, completion: @escaping (Result<Response<User>?, Error>) -> Void) {
        let params = [
            "currentPassword": newPassword,
            "newPassword": newPassword
        ]
        apiClient.performPatch(withResponseType: Response<User>.self, withSubpath: "/users/change-password", withParams: params, completion: completion)
    }
}

