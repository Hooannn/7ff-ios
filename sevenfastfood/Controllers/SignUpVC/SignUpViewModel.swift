//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation
import Alamofire
protocol SignUpViewModelDelegate: AnyObject {
    func didUpdateLoading(_ isLoading: Bool)
    func didSignUpSuccess(with data: Response<SignInResponseData>?)
    func didSignUpFailure(with error: Error?)
}

final class SignUpViewModel {
    weak var delegate: SignUpViewModelDelegate!
    func performSignUp(with form: SignUpForm) {
        delegate.didUpdateLoading(true)
        
        AuthenService.shared.signUp(with: form) { [weak self]
            result in
            switch result {
            case.success(let data):
                self!.delegate.didSignUpSuccess(with: data)
            case .failure(let error):
                self!.delegate.didSignUpFailure(with: error)
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
                self!.delegate.didSignUpSuccess(with: data)
            case .failure(let error):
                self!.delegate.didSignUpFailure(with: error)
            }
            self!.delegate.didUpdateLoading(false)
        }
    }
}
