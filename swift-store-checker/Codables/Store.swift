//
//  Store.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/5/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation

struct Store: Codable {
    let address: Address
    let city: String
    let country: String
    let directionsUrl: String
    let hoursUrl: String
    let makeReservationUrl: String
    let partsAvailability: Dictionary<String, PartAvailability>
    let phoneNumber: String
    let reservationUrl: String
    let state: String
    let storeDistanceVoText: String
    let storeEmail: String
    let storeHours: StoreHours
    let storeImageUrl: String
    let storeListNumber: Int
    let storeName: String
    let storeNumber: String
    let storedistance: Float
    let storelatitude: Float
    let storelistnumber: Int
    let storelongitude: Float
}
