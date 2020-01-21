//
//  main.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 12/30/19.
//  Copyright © 2019 Gerard Giné. All rights reserved.
//

import Foundation
import Combine

// TODO: RETRIAL_INTERVAL and the rest of the config info should be read from Config.plist
let RETRIAL_INTERVAL: UInt32 = 10

let productToFind = Product(partNumber: "MWP22AM/A", name: "AirPods Pro")
let retailStores = [
    "4THS":  RetailStore(code: "R414", name: "4th Street (Berkeley)"),
    "BAYS":  RetailStore(code: "R057", name: "Bay Street (Emeryville)"),
    "CHEST": RetailStore(code: "R217", name: "Chestnut Street (SF)"),
    "COMA":  RetailStore(code: "R071", name: "Corte Madera"),
    "ROSE":  RetailStore(code: "R298", name: "Roseville"),
    "SACR":  RetailStore(code: "R070", name: "Sacramento Arden Fair"),
    "SFUS":  RetailStore(code: "R075", name: "San Francisco Union Square"),
    "STPL":  RetailStore(code: "R101", name: "Stoneridge Mall (Pleasanton)"),
    "STSF":  RetailStore(code: "R033", name: "Stonestown (SF)"),
    "WACR":  RetailStore(code: "R014", name: "Walnut Creek")
]

var storesToCheck: [RetailStore] = []
if CommandLine.argc > 1 && CommandLine.arguments.contains("-h") {
    print("Usage: \(CommandLine.arguments.first!) [STORE, STORE, ...]")
    print("Available stores:")
    for (code, store) in retailStores {
        print("  \(code): \(store.name)")
    }
    exit(0)
} else if CommandLine.argc > 1 {
    // Arguments have been passed. We gotta filter what stores to check.
    var firstArg = true
    for argument in CommandLine.arguments {
        if firstArg {
            firstArg = false
        } else {
            // TODO: Make this safer
            storesToCheck.append(retailStores[argument]!)
        }
    }
} else {
    for (_, store) in retailStores {
        storesToCheck.append(store)
    }
}

var iterationCount = 0
var lastDate: [String:String] = [:]
var okResponses = [Agent.Response<PickupMessage>]()
var koResponses = [Agent.Response<PickupMessage>]()

var pickupsMessages = [PickupMessage]()
var publishers = [AnyPublisher<Agent.Response<PickupMessage>, Error>]()
var merged: AnyCancellable

func checkResponses(responses: [Agent.Response<PickupMessage>]) -> Void {
    for response in responses {
        let urlResponse = response.response

        if let httpResponse = urlResponse as? HTTPURLResponse {
            if httpResponse.statusCode == 200 {
                okResponses.append(response)
            } else {
                koResponses.append(response)
            }
        } else {
            koResponses.append(response)
        }
    }

    for response in okResponses {
        let value = response.value

        let storeName = value.body.stores.first!.storeName
        let storeNumber = value.body.stores.first!.storeNumber
        print("Successful response from \(storeName)")

        let pickupSearchQuote = value.body.stores.first!.partsAvailability[productToFind.partNumber]!.pickupSearchQuote
        let components = pickupSearchQuote.components(separatedBy: "<br/>")
        if components.count == 2 {
            let date = components[1]
            if iterationCount > 0 && lastDate[storeNumber] != nil && lastDate[storeNumber] != date {
                let successMsg = "The new date for \(storeName) is \(date)"
                print("---> \(successMsg)")
                // TODO: Twilio stuff with successMsg
            } else if iterationCount == 0 {
                print("First iteration: \(date)")
            } else {
                print("Date hasn't changed (\(date))")
            }
            lastDate[storeNumber] = date
        } else {
            print("The result couldn't be split by '<br/>': \(pickupSearchQuote)")
        }
    }

    for response in koResponses {
        // TODO: when a request is unsuccesful, no responses (successful or not) are passed
    }

    okResponses.removeAll()
    koResponses.removeAll()
    iterationCount += 1
}

while true {
    print("\n*** Starting new check @ \(Date().description(with: .current))")
    for storeToCheck in storesToCheck {
        publishers.append(AppleRetailAPI.pickup(store: storeToCheck, product: productToFind))
    }

    merged = Publishers.MergeMany(publishers)
//        .print()
        .collect()
        .sink(
            receiveCompletion: { _ in },
            receiveValue: {
                checkResponses(responses: $0)
            }
        )

    publishers.removeAll()

    sleep(RETRIAL_INTERVAL)
}
