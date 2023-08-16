//
//  HomeViewModel.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 09/08/2023.
//

import Foundation


final class HomeViewModel {
    private let categoriesService = CategoriesService()
    
    func fetchCategories() {
        categoriesService.fetchCategories {
            result in switch result {
            case.success(let data):
                print(data)
            case.failure(let error):
                print(error)
            }
        }
    }
}
