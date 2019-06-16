//
//  Endpoint.swift
//  Le Baluchon
//
//  Created by pith on 02/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation
import UIKit

let weatherAPI_KEY = "4ba15fab0577b7ef6af21d2e8ef46019"
let currencyAPI_KEY = "0b2448d5e7229823402c0052afd30f3f"

enum EndPoint {

    case weatherLoc(lat: String, lon: String)
    case weatherCity(name: String)
    case translation
    case currency

    var baseURLString: String {
        switch self {
        case .weatherLoc:
            return "http://api.openweathermap.org/data/2.5/weather?&units=metric"
        case .weatherCity:
            return "http://api.openweathermap.org/data/2.5/weather?&units=metric"
        case .currency:
            return "http://data.fixer.io/api/"
        case .translation:
            return "http://googleTranslate"

        }
    }

    var completeURLString: String {
        switch self {
        case .weatherLoc(let lat,let lon):
            return baseURLString + "&lat=\(lat)&lon=\(lon)&appid=\(weatherAPI_KEY)"
        case .weatherCity(let cityName):
            return baseURLString + "&q=\(cityName)&appid=\(weatherAPI_KEY)"
        case .currency:
            return baseURLString + "latest?access_key=\(currencyAPI_KEY)"
        case .translation:
            return ""
        }
    }
    
    var url: URL {
        return URL(string: completeURLString)!
    }
}




