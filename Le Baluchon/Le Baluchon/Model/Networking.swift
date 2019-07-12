//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

protocol RequestApi {
    func request<T>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) where T : Decodable
}

class Networking: RequestApi {

    func request<T: Decodable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) {

        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            do {
                if let data = data {
                    let parsedJson = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(parsedJson))
                }
            } catch let decodeJsonError {
                completionHandler(.failure(decodeJsonError))
            }
        }
        task.resume()
    }
}
