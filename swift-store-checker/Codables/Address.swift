//
//  Address.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/5/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation

struct Address: Codable {
    let address: String
    let address2: String
    let address3: String?
    let postalCode: String
}
