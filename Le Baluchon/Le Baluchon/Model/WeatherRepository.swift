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

    let networking: RequestApi
    init(networking: RequestApi) {
        self.networking = networking
    }

    func getWeatherDataByCity(cityName: String, completion: @escaping (_ weatherData: WeatherProperties) -> ()) {

        networking.request(endpoint: EndPoint.weatherCity(name: cityName) ) { (result: Result<WeatherProperties, Error>) in
            switch result {
            case .failure(let error):
                print("Failed to fetch: ", error)
                // completion(error)

            case.success(let parsedWeatherPropertiesByCityName):
                print(parsedWeatherPropertiesByCityName)

                completion(parsedWeatherPropertiesByCityName)
            }
        }
    }

    func getWeatherDataByGps(lat: String, lon: String, completion: @escaping (_ weatherData: WeatherProperties) -> ()) {

        networking.request(endpoint: EndPoint.weatherLoc(lat: lat, lon: lon)) { (result: Result<WeatherProperties, Error>) in
            switch result {
            case.failure(let error):
                print("Failed to get localizations: ",error)
                
            case.success(let parsedWeatherPropertiesByLocalization):
                print(parsedWeatherPropertiesByLocalization)

                completion(parsedWeatherPropertiesByLocalization)
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







