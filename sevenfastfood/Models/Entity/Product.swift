//
//  Product.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation

struct Product: Codable {
    let _id: String?
    let name: Content
    let description: Content
    let price: Double
    let stocks: Int?
    let category: Category?
    let isAvailable: Bool
    let rating: Double?
    let ratingCount: Int?
    let featuredImages: [String]?
}
