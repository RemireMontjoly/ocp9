//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation


class Networking {    // quelles erreurs remontent?les 2?  // generic? <T: Equatable> non?

    func request(endpoint: EndPoint, completionHandler: @escaping (Result<WeatherProperties, Error>) -> ()) {

        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                // completion(nil, error)
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("server error")
                return
            }
            do {
                let parsedJson = try JSONDecoder().decode(WeatherProperties.self, from: data!)
                completionHandler(.success(parsedJson))
                print(parsedJson)
                // completion(error, nil)

            } catch let decodeJsonError {
                print("err 2")
                completionHandler(.failure(decodeJsonError))
                // completion(nil, error)
            }
        }
        task.resume()
    }
}
