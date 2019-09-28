//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

protocol Networking {
    func request<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ())
}

enum NetworkingError: Error {
    case invalideUrl
    case invalidCityName
    case fetchingError
    case decodeJsonError
}

class NetworkingImplementation: Networking {

    private var networkingSession: URLSession
    init(networkingSession: URLSession) {
        self.networkingSession = networkingSession
    }
    
    func request<T: Decodable>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = endpoint.url else {
            completionHandler(.failure(NetworkingError.invalideUrl))
            // This error will display generic case.
            print("Bad Url! \(NetworkingError.invalideUrl)")
            return
        }
        
        let task = networkingSession.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(NetworkingError.fetchingError))
                // This error will be displayed to the user cause it's probably an Internet issue.
                print("Failed to fetch.No Data! \(error)")
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 404 {
                completionHandler(.failure(NetworkingError.invalidCityName))
                // This error will be displayed to the user only for the weather city fetching case -> City not found.
                print("server error")
            }
            do {
                if let data = data {
                    let parsedJson = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(parsedJson))
                }
            } catch {
                completionHandler(.failure(NetworkingError.decodeJsonError))
                // this error will display a generic case.
                print("Failed to decode!\(NetworkingError.decodeJsonError)")
            }
        }
        task.resume()
    }
}

extension NetworkingError: Equatable {
    static func ==(lhs: NetworkingError, rhs: NetworkingError) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
