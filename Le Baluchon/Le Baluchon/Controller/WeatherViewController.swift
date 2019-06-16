//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by pith on 16/05/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit
import CoreLocation

var cityName = "New+York"

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    let weatherService = WeatherService(networking: Networking())


    //For GPS location: Instance of locationManager
    let locationManager = CLLocationManager()

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var newYorkTemp: UILabel!
    @IBOutlet weak var newYorkConditionIcon: UIImageView!

    //UI for GPS localization
    @IBOutlet weak var localTemperatureLabel: UILabel!
    @IBOutlet weak var localWeatherIcon: UIImageView!
    @IBOutlet weak var localCityNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        weatherService.getWeatherData(endPoint: EndPoint.weatherCity(name: cityName), completion: upDateUI(weatherProperties:))
        //        WeatherService.getWeatherData(url: EndPoint.weatherCity(name: cityName).url , completion: upDateUI(weatherProperties:))

        // For GPS location:
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()//Send a msg (delegate) when accuracy is ok

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let changeCityViewController = segue.destination as? ChangeCityViewController {
            changeCityViewController.delegate = self
        }
    }

    //MARK: - Update UI
    func upDateUI(weatherProperties: WeatherProperties) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName.replacingOccurrences(of: "+", with: " ")
            self.newYorkTemp.text = String(Int(weatherProperties.cityTemp.temp)) + "°C"
            let iconId = weatherProperties.weatherConditions[0].id
            self.newYorkConditionIcon.image = UIImage(named: WeatherService.updateWeatherIcon(condition: iconId) )
        }
    }

    func upDateUIWithGps(weatherProperties: WeatherProperties) {
        DispatchQueue.main.async {
            self.localTemperatureLabel.text = String(Int(weatherProperties.cityTemp.temp)) + "°C"
            self.localCityNameLabel.text = weatherProperties.cityName
            let iconId = weatherProperties.weatherConditions[0].id
            self.localWeatherIcon.image = UIImage(named: WeatherService.updateWeatherIcon(condition: iconId))
        }
    }

    //MARK: - LocationManager Delegate methods
    // For GPS location.Methode triggered by startUpdatingLocation()
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {           //Checking valide location
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil

            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            //            WeatherService.getWeatherData(url: EndPoint.weatherLoc(lat: latitude, lon: longitude).url, completion: upDateUIWithGps(weatherProperties:))
            weatherService.getWeatherData(endPoint: EndPoint.weatherLoc(lat: latitude, lon: longitude), completion: upDateUIWithGps(weatherProperties:))
        }
    }

    // If GPS Location unavailable
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        localCityNameLabel.text = "Location unavailable"
    }

}


extension WeatherViewController: ChangeCityDelegate {
    func userEnteredANewCityName(city: String) {

        let cityNameReplaceSpace = city.replacingOccurrences(of: " ", with: "+")
        cityName = cityNameReplaceSpace.capitalized
        //        WeatherService.getWeatherData(url: EndPoint.weatherCity(name: cityName).url, completion: upDateUI(weatherProperties:))
        weatherService.getWeatherData(endPoint: EndPoint.weatherCity(name: cityName), completion: upDateUI(weatherProperties:))
    }
}


