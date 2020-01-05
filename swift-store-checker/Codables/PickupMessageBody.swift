//
//  PickupMessageBody.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/5/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation

struct PickupMessageBody: Codable {
    let errorMessage: String?
    let little: Bool
    let notAvailableNearOneStore: String
    let notAvailableNearby: String
    let overlayInitiatedFromWarmStart: Bool
    let pickupLocation: String
    let pickupLocationLabel: String
    let stores: [Store]
    let storesCount: String
    let viewMoreHoursLinkText: String
    let viewMoreHoursVoText: String
    let warmDudeWithAPU: Bool
}
