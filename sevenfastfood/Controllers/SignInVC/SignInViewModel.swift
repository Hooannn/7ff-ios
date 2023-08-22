//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation

import Foundation
import Alamofire
protocol SignInViewModelDelegate: AnyObject {
    func didUpdateLoading(_ isLoading: Bool)
    func didSignInSuccess(with data: Response<SignInResponseData>?)
    func didSignInFailure(with error: Error?)
}

final class SignInViewModel {
    weak var delegate: SignInViewModelDelegate!
    func performSignIn(with form: SignInForm) {
        delegate.didUpdateLoading(true)
        
        AuthenService.shared.signIn(with: form) { [weak self]
            result in
            switch result {
            case.success(let data):
                self!.delegate.didSignInSuccess(with: data)
            case .failure(let error):
                self!.delegate.didSignInFailure(with: error)
            }
            self!.delegate.didUpdateLoading(false)
        }
    }
    
    func performGoogleAuthentication(with accessToken: String) {
        delegate.didUpdateLoading(true)
        
        AuthenService.shared.authenWithGoogle(with: accessToken) { [weak self]
            result in
            switch result {
            case.success(let data):
                self!.delegate.didSignInSuccess(with: data)
            case .failure(let error):
                self!.delegate.didSignInFailure(with: error)
            }
            self!.delegate.didUpdateLoading(false)
        }
    }
}
