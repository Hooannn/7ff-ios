//
//  Voucher.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 07/09/2023.
//

import Alamofire
final class VouchersService {
    private var apiClient = APIClient.shared
    static let shared = VouchersService()

    public func verify(withCode code: String, completion: @escaping (Result<Response<Voucher>?, Error>) -> Void) {
        let params = [
            "code": code
        ]
        apiClient.performGet(withResponseType: Response<Voucher>.self, withSubpath: "/vouchers/validate", withParams: params, completion: completion)
    }
}
