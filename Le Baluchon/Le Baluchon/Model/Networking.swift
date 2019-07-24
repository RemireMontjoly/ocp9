//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

protocol RequestApi {
    func request<T: Decodable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) //where T : Decodable
}
enum NetworkingError: Error {
    case invalideUrl
}

class Networking: RequestApi {

    func request<T: Decodable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = endpoint.url else {
            completionHandler(.failure(NetworkingError.invalideUrl))
            print("Bad Url!")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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
                print("Unexpected error happen!")
                completionHandler(.failure(decodeJsonError))

            }
        }
        task.resume()
    }
}
