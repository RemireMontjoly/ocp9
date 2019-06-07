//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 04/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation


class Networking {

    func request(endpoint: EndPoint, completionHandler: @escaping (Data?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: endpoint.url) { (data, response, error) in
            guard let data = data, error == nil else {
                completionHandler(nil, error)
                print ("error: no Data")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("server error")
                return
            }
            completionHandler(data, error)

//            do {
//                let weatherData = try JSONDecoder().decode(EndPoint.self, from: data)
//                completionHandler(weatherData, nil)
//            } catch {
//                print(error.localizedDescription)
//            }
        }
        task.resume()
    }
}
