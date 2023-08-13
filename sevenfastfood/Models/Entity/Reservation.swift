//
//  Reservation.swift
//  sevenfastfood
//
//  Created by Nguyen Duc Khai Hoan on 13/08/2023.
//

import Foundation

struct ReservationContacts: Codable {
    let phone: String?
    let email: String?
}

enum ReservationStatus: String, Codable {
    case Processing, Done
}

struct Reservation: Codable {
    let customerId: String?
    let note: String?
    let contacts: ReservationContacts?
    let underName: String
    let bookingTime: Int
    let reservationFor: String?
    //let attrs: [String: AnyCodable]?
    let status: ReservationStatus
}
