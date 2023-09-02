//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation


final class ProfileViewModel {
    func performSignOut(completion: @escaping () -> Void) {
        LocalData.shared.cleanup()
        completion()
    }
    
    func getUser(completion: @escaping (User?) -> Void) {
        let user = LocalData.shared.getLoggedUser()
        
        completion(user)
    }
}
