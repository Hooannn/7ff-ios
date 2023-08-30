//
//  Voucher.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation
enum DiscountType: String, Codable {
    case percent, amount
}
struct Voucher: Codable {
    let code: String
    let discountType: DiscountType
    let discountAmount: Double
    let expiredDate: Int?
    let totalUsageLimit: Int?
}
