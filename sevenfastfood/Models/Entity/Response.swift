//
//  Responses.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation


struct Response<DataType: Codable>: Codable {
    let code: Int?
    let data: DataType?
    let success: Bool?
    let message: String?
    let total: Int?
    let took: Int?
}

struct SignUpResponseData: Codable {
    let email: String
    let password: String
}

struct SignInResponseData: Codable {
    let user: User
    let accessToken: String
    let refreshToken: String
}
