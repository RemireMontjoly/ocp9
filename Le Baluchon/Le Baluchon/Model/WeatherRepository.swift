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
//MARK: - Class for API call
class WeatherRepository {

    private let networking: Networking
    init(networking: Networking) {
        self.networking = networking
    }

    func getWeatherDataByCity(cityName: String, completion: @escaping (Result<WeatherProperties, Error>) -> ()) {

        networking.request(endpoint: Endpoint.weatherCity(name: cityName).url ) { (result: Result<WeatherProperties, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    func getWeatherDataByGps(lat: String, lon: String, completion: @escaping (Result<WeatherProperties, Error>) -> ()) {

        networking.request(endpoint: Endpoint.weatherLoc(lat: lat, lon: lon).url) { (result: Result<WeatherProperties, Error>) in
            DispatchQueue.main.async {
                completion(result)
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







