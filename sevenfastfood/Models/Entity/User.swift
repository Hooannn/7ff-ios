//
//  User.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation

enum UserRole: String, Codable {
    case User, Admin, SuperAdmin
}

struct User: Codable {
    let _id: String
    let firstName: String
    let lastName: String
    let email: String
    let address: String?
    let phoneNumber: String?
    let refreshToken: String?
    let avatar: String?
    let orders: [String]?
    let role: UserRole
}
