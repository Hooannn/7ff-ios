//
//  AuthenService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation
import Alamofire
final class AuthenService {
    private var apiClient = APIClient.shared
    public func signup(with form: SignUpForm, completion: @escaping (Result<Response<SignUpResponseData>?, Error>) -> Void) {
        let params: [String: String] = [
            "email": form.email,
            "password": form.password,
            "firstName": form.firstName,
            "lastName": form.lastName
        ]
        apiClient.performPost(withResponseType: Response<SignUpResponseData>.self, withSubpath: "/auth/sign-up/email", withParams: params, completion: completion)
    }
}
