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

    let weatherCondition = WeatherRepository(networking: Networking())


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

        userEnteredANewCityName(city: cityName)
//        weatherCondition.getWeatherDataByCity(cityName: cityName) { result in
//            switch result {
//            case .success(let weatherProperties):
//                self.updateUI(weatherProperties: weatherProperties)
//            case .failure(let error):
//                switch error {
//                case NetworkingError.invalideUrl:
//                    ErrorAlert.showGenericAlert(on: self)
//
//                case NetworkingError.fetchingError:
//                    ErrorAlert.showUnableToFetchDataAlert(on: self)
//
//                default:
//                    ErrorAlert.showGenericAlert(on: self)
//                }
//            }
//
//        }

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
    func updateUI(weatherProperties: WeatherProperties) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName.replacingOccurrences(of: "+", with: " ")
            self.newYorkTemp.text = String(Int(weatherProperties.cityTemp.temp)) + "°C"
            let iconId = weatherProperties.weatherConditions[0].id
            self.newYorkConditionIcon.image = UIImage(named: WeatherRepository.updateWeatherIcon(condition: iconId) )
        }
    }

    func upDateUIWithGps(weatherProperties: WeatherProperties) {
        DispatchQueue.main.async {
            self.localTemperatureLabel.text = String(Int(weatherProperties.cityTemp.temp)) + "°C"
            self.localCityNameLabel.text = weatherProperties.cityName
            let iconId = weatherProperties.weatherConditions[0].id
            self.localWeatherIcon.image = UIImage(named: WeatherRepository.updateWeatherIcon(condition: iconId))
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

            weatherCondition.getWeatherDataByGps(lat: latitude, lon: longitude, completion: upDateUIWithGps(weatherProperties:))
        }
    }

    // If GPS Location unavailable
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        ErrorAlert.showUnableToFetchDataAlert(on: self)
        localCityNameLabel.text = "Location unavailable"
    }
}

extension WeatherViewController: ChangeCityDelegate {
    func userEnteredANewCityName(city: String) {

        let cityWithoutSpace = city.replacingOccurrences(of: " ", with: "+")
        let cityWithoutAccent = cityWithoutSpace.folding(options: .diacriticInsensitive, locale: .current)
        let cityWithCapitalizedFirstLetter = cityWithoutAccent.capitalized
        cityName = cityWithCapitalizedFirstLetter

        weatherCondition.getWeatherDataByCity(cityName: cityName) { result in
            switch result {
            case .success(let weatherProperties):
                self.updateUI(weatherProperties: weatherProperties)
            case .failure(let error):
                switch error {
                case NetworkingError.invalidCityName:
                    ErrorAlert.showCityNotFoundAlert(on: self)

                case NetworkingError.invalideUrl:
                    ErrorAlert.showGenericAlert(on: self)

                case NetworkingError.fetchingError:
                    ErrorAlert.showUnableToFetchDataAlert(on: self)

                default:
                    ErrorAlert.showGenericAlert(on: self)

                }
            }
        }
    }
}


