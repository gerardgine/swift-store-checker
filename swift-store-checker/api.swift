//
//  agent.swift
//  swift-store-checker
//
//  Created by Gerard Giné on 1/4/20.
//  Copyright © 2020 Gerard Giné. All rights reserved.
//

import Foundation
import Combine

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    func run<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result -> Response<T> in
                // TODO: Check what to do on unsuccessful requests: the decoder will fail!
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
//            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum AppleRetailAPI {
    static let agent = Agent()
    static let base = URL(string: "https://www.apple.com/shop/retail")!

    static func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }

    static func pickup(store: RetailStore, product: Product) -> AnyPublisher<Agent.Response<PickupMessage>, Error> {
        // We ended up not using AppleRetailAPI.run() because we want both the decoded value and the urlResponse
//        return run(URLRequest(url: URL(string: "\(base.absoluteString)/pickup-message?parts.0=\(product.partNumber.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&store=\(store.code)")!))
        return agent.run(URLRequest(url: URL(string: "\(base.absoluteString)/pickup-message?parts.0=\(product.partNumber.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&store=\(store.code)")!))
    }
}
