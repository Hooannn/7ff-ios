//
//  CheckoutService.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 07/09/2023.
//
struct CheckoutItem {
    let product: String
    let quantity: Int
}

struct CheckoutForm {
    let customerId: String
    let isDelivery: Bool?
    let items: [CheckoutItem]
    let deliveryPhone: String?
    let deliveryAddress: String?
    let voucher: String?
    let note: String?
}

import Alamofire
final class CheckoutService {
    private var apiClient = APIClient.shared
    static let shared = CheckoutService()

    public func checkout(with form: CheckoutForm, completion: @escaping (Result<Response<CreatedOrder>?, Error>) -> Void) {
        var params = [
            "customerId": form.customerId,
            "isDelivery": form.isDelivery ?? false,
            "items": form.items.map {
                item in
                return [
                    "product": item.product,
                    "quantity": item.quantity
                ] as [String : Any]
            }
        ] as [String : Any]
        
        if let deliveryPhone = form.deliveryPhone {
            params["deliveryPhone"] = deliveryPhone
        }
        if let deliveryAddress = form.deliveryAddress {
            params["deliveryAddress"] = deliveryAddress
        }
        if let voucher = form.voucher {
            params["voucher"] = voucher
        }
        if let note = form.note {
            params["note"] = note
        }
        
        apiClient.performPost(withResponseType: Response<CreatedOrder>.self, withSubpath: "/checkout?locale=en", withParams: params, completion: completion)
    }
}
