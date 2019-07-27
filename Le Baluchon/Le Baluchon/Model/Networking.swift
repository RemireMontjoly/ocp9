//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

protocol ApiRequest {
    func request<T: Decodable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) //where T : Decodable
}
enum NetworkingError: Error {
    case invalideUrl
    case invalidCityName
}

class Networking: ApiRequest {

    func request<T: Decodable>(endpoint: EndPoint, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = endpoint.url else {
            completionHandler(.failure(NetworkingError.invalideUrl))

            print("Bad Url!")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))

                print("Failed to fetch.No Data!")

            } else {
                if let response = response as? HTTPURLResponse, response.statusCode == 404 {
                    completionHandler(.failure(NetworkingError.invalidCityName))

                    print("City not found!")
                }
            }
            do {
                if let data = data {
                    let parsedJson = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(parsedJson))
                }
            } catch let decodeJsonError {
                completionHandler(.failure(decodeJsonError))

                print("Failed to decode!")
            }
        }
        task.resume()
    }
}
