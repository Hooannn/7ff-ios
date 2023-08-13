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
    func didSignUpSuccess(with data: Response<SignUpResponseData>?)
    func didSignUpFailure(with error: Error?)
}

final class SignUpViewModel {
    weak var delegate: SignUpViewModelDelegate!
    private var authenService = AuthenService()
    func performSignUp(with form: SignUpForm) {
        delegate.didUpdateLoading(true)
        
        authenService.signup(with: form) { [weak self]
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
