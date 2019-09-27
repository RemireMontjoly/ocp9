//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by pith on 06/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation


struct CurrencyProperties: Decodable {
    let rates: [String: Double]
}

class CurrencyRepository {

    private let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getCurrency(completion: @escaping (Result<CurrencyProperties, Error>) -> ()) {

        networking.request(endpoint: Endpoint.currency) { (result: Result<CurrencyProperties, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}



