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

class CurrencyService {

    static func getCurrencyData(completionHandler: @escaping (_ currency: CurrencyProperties) -> ()) {
        let task = URLSession.shared.dataTask(with: EndPoint.currency.url) { (data, response, error) in
            guard let data = data, error == nil else {
                print(error)
                print(response)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("server error")
                return
            }
            let decoder = JSONDecoder()
            print (response.statusCode)
            do {
                let currencyListResponse = try decoder.decode(CurrencyProperties.self, from: data)
                //  let currency = currencyListResponse.rates.keys.map({$0})

                completionHandler(currencyListResponse)

            }
            catch {
                print ("je suis là")
                print (error)
            }
        }
        task.resume()
    }
}

