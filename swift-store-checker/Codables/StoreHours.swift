//
//  StoreHours.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/5/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation

struct StoreHours: Codable {
    let bopisPickupDays: String
    let bopisPickupHours: String
    let hours: [Hour]
    let storeHoursText: String
}
