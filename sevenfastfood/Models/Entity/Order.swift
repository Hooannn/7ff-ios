//
//  Order.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation

enum OrderStatus: String, Codable {
    case Processing, Delivering, Done, Cancelled
}

struct Order: Codable {
    let customerId: String
    let items: [CartItem]
    let totalPrice: Double
    let voucher: Voucher?
    let note: String?
    let isDelivery: Bool
    let deliveryAddress: String?
    let deliveryPhone: String?
    let rating: Double?
    let status: OrderStatus
}
