//
//  Networking.swift
//  Le Baluchon
//
//  Created by pith on 16/05/2019.
//  Copyright © 2019 dino. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

//MARK: - Struct for mapping JSON
struct Weather: Decodable {
    let id: Int
    let description: String
}
struct Main: Decodable {
    let temp: Double
}
struct WeatherProperties: Decodable {
    let cityName: String
    let cityTemp: Main
    let weatherConditions: [Weather]

    private enum CodingKeys: String, CodingKey {
        case cityName = "name"
        case cityTemp = "main"
        case weatherConditions = "weather"
    }
}
//MARK: - Struct for API call
struct WeatherService {

    let networking: Networking
    init(networking: Networking) {
        self.networking = networking
    }

    func getWeatherData(endPoint: EndPoint, completion: @escaping (_ weatherData: WeatherProperties) -> ()) {

        networking.request(endpoint: endPoint ) { (result) in
            switch result {
            case .failure(let error):
                print("Failed to fetch: ", error)
            case.success(let parsedWeatherProperties):
                print(parsedWeatherProperties)

                completion(parsedWeatherProperties)

                print(parsedWeatherProperties.cityName)
                print(parsedWeatherProperties.cityTemp.temp)
                print(parsedWeatherProperties.weatherConditions[0].id)
                print(parsedWeatherProperties.weatherConditions[0].description)
            }
        }
    }

    static func updateWeatherIcon(condition: Int) -> String {

        switch (condition) {

        case 0...300 :
            return "tstorm1"

        case 301...500 :
            return "light_rain"

        case 501...600 :
            return "shower3"

        case 601...700 :
            return "snow4"

        case 701...771 :
            return "fog"

        case 772...799 :
            return "tstorm3"

        case 800 :
            return "sunny"

        case 801...804 :
            return "cloudy2"

        case 900...903, 905...1000  :
            return "tstorm3"

        case 903 :
            return "snow5"

        case 904 :
            return "sunny"

        default :
            return "dunno"
        }
    }

}




//            if let json1 = try? JSONSerialization.jsonObject(with: data, options: []) {
//                print(json1)
//            }
//            if let json2 = String(data: data, encoding: String.Encoding.utf8) {
//                print(json2)
//            }
//    if let json1 = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
//        print(json1)
//    }


