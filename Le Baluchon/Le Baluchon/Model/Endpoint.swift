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
let translationAPI_KEY = "my-APIKey"

enum Endpoint {

    case weatherLoc(lat: String, lon: String)
    case weatherCity(name: String)
    case currency
    case translation(myText: String)

    var url: URL? {
        var urlComponents = URLComponents(string: baseUrlString)
        urlComponents?.queryItems = parameters
        return urlComponents?.url
    }

    var baseUrlString: String {
        switch self {
        case .weatherCity, .weatherLoc:
            return "http://api.openweathermap.org/data/2.5/weather?"
        case .currency:
            return "http://data.fixer.io/api/latest?"
        case .translation:
            return "https://translation.googleapis.com/language/translate/v2?"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .weatherLoc(let lat, let lon):
            return [URLQueryItem(name: "lat", value: lat),
                    URLQueryItem(name: "lon", value: lon),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: weatherAPI_KEY)
            ]
        case .weatherCity(let cityName):
            return [URLQueryItem(name: "q", value: cityName),
                    URLQueryItem(name: "units", value: "metric"),
                    URLQueryItem(name: "appid", value: weatherAPI_KEY)
            ]
        case .currency:
            return [URLQueryItem(name: "access_key", value: currencyAPI_KEY)
            ]
        case .translation(let textToTranslate):
            return [URLQueryItem(name: "q", value: textToTranslate),
                    URLQueryItem(name: "format", value: "text"),
                    URLQueryItem(name: "target", value: "en"),
                    URLQueryItem(name: "key", value: translationAPI_KEY)
            ]
        }
    }
}



//    var finalUrl: URL? {
//        switch self {
//        case .weatherLoc(let lat, let lon):
//            return weatherLocURL(lat: lat, lon: lon)
//        case .weatherCity(let cityName):
//            return weatherCityURL(cityName: cityName)
//        case .currency:
//            return currencyURL()
//        case .translation(let myText):
//            return translateURL(textToTranslate: myText)
//        }
//    }
//    // Currency API
//    func currencyURL() -> URL? {
//        var baseUrl = URLComponents(string:"http://data.fixer.io/api/latest?")
//        let queryItemsArray = [URLQueryItem(name: "access_key", value: currencyAPI_KEY)
//        ]
//        baseUrl?.queryItems = queryItemsArray
//        return baseUrl?.url
//    }
//
//    // Weather by city API
//    func weatherCityURL(cityName: String) -> URL? {
//        var baseUrl = URLComponents(string:"http://api.openweathermap.org/data/2.5/weather?")
//        let queryItemsArray = [URLQueryItem(name: "q", value: cityName),
//                               URLQueryItem(name: "units", value: "metric"),
//                               URLQueryItem(name: "appid", value: weatherAPI_KEY)
//        ]
//        baseUrl?.queryItems = queryItemsArray
//        return baseUrl?.url
//    }
//
//    // Weather by GPS API
//    func weatherLocURL(lat: String, lon: String) -> URL? {
//        var baseUrl = URLComponents(string:"http://api.openweathermap.org/data/2.5/weather?")
//        let queryItemsArray = [URLQueryItem(name: "lat", value: lat),
//                               URLQueryItem(name: "lon", value: lon),
//                               URLQueryItem(name: "units", value: "metric"),
//                               URLQueryItem(name: "appid", value: weatherAPI_KEY)
//        ]
//        baseUrl?.queryItems = queryItemsArray
//        return baseUrl?.url
//    }
//
//    // Translate API
//    func translateURL(textToTranslate: String) -> URL? {
//        var baseUrl = URLComponents(string: "https://translation.googleapis.com/language/translate/v2?")
//        let queryItemsArray = [URLQueryItem(name: "q", value: textToTranslate),
//                               URLQueryItem(name: "format", value: "text"),
//                               URLQueryItem(name: "target", value: "en"),
//                               URLQueryItem(name: "key", value: translationAPI_KEY)
//        ]
//        baseUrl?.queryItems = queryItemsArray
//        return baseUrl?.url
//    }
//}
