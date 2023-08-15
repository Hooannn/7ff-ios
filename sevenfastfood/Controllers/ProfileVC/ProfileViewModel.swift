//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation


final class ProfileViewModel {
    private let localDataClient = LocalData.shared
    public func performSignOut(completion: @escaping () -> Void) {
        localDataClient.cleanup()
        completion()
    }
}
