//
//  PartAvailability.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/5/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation

struct PartAvailability: Codable {
    let ctoOptions: String
    let partNumber: String
    let pickupDisplay: String
    let pickupSearchQuote: String
    let purchaseOption: String
    let storePickEligible: Bool
    let storePickupLabel: String
    let storePickupLinkText: String
    let storePickupProductTitle: String
    let storePickupQuote: String
    let storeSearchEnabled: Bool
    let storeSelectionEnabled: Bool
}
