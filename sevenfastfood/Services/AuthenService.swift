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
    private var localDataClient = LocalData.shared
    static let shared = AuthenService()
    public func signUp(with form: SignUpForm, completion: @escaping (Result<Response<SignInResponseData>?, Error>) -> Void) {
        let params: [String: String] = [
            "email": form.email,
            "password": form.password,
            "firstName": form.firstName,
            "lastName": form.lastName
        ]
        apiClient.performPost(withResponseType: Response<SignUpResponseData>.self, withSubpath: "/auth/sign-up/email", withParams: params) {
            result in
            switch result {
            case .success(let data):
                guard let email = data?.data?.email, let password = data?.data?.password else {
                    completion(.failure(NSError(domain: "AuthenService.signUp", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Missing email and password when signup success"])))
                    return
                }
                let signInForm = SignInForm(email: email, password: password)
                self.signIn(with: signInForm) {
                    result in completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func signIn(with form: SignInForm, completion: @escaping (Result<Response<SignInResponseData>?, Error>) -> Void) {
        let params: [String: String] = [
            "email": form.email,
            "password": form.password
        ]
        apiClient.performPost(withResponseType: Response<SignInResponseData>.self, withSubpath: "/auth/sign-in/email", withParams: params) {
            result in
            switch result {
            case .success(let data):
                if let accessToken = data?.data?.accessToken {
                    self.localDataClient.setAccessToken(accessToken)
                }
                if let refreshToken = data?.data?.refreshToken {
                    self.localDataClient.setRefreshToken(refreshToken)
                }
                if let user = data?.data?.user {
                    self.localDataClient.setLoggedUser(user)
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func authenWithGoogle(with accessToken: String, completion: @escaping (Result<Response<SignInResponseData>?, Error>) -> Void) {
        let params: [String: String] = [
            "googleAccessToken": accessToken
        ]
        apiClient.performPost(withResponseType: Response<SignInResponseData>.self, withSubpath: "/auth/google-auth", withParams: params) {
            result in
            switch result {
            case .success(let data):
                if let accessToken = data?.data?.accessToken {
                    self.localDataClient.setAccessToken(accessToken)
                }
                if let refreshToken = data?.data?.refreshToken {
                    self.localDataClient.setRefreshToken(refreshToken)
                }
                if let user = data?.data?.user {
                    self.localDataClient.setLoggedUser(user)
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
