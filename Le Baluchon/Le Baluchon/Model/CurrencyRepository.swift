//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by pith on 06/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation


struct CurrencyProperties: Decodable {
    let rates: [String: Float]
}

class CurrencyRepository {

    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }

    func getCurrency(completion: @escaping (_ currency: CurrencyProperties) -> ()) {

        networking.request(endpoint: EndPoint.currency) { (result: Result<CurrencyProperties, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    
                    
                    print("Failed to fetch", error)

                case .success(let parsedCurrency):

                    completion(parsedCurrency)
                }
            }
        }
    }

    
}
