//
//  WeatherTestCase.swift
//  Le BaluchonTests
//
//  Created by pith on 01/10/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class MockNetworkingWeather: Networking {
    var shouldReturnError = true

    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    func request<T>(endpoint: URL?, completionHandler: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        if shouldReturnError {
            completionHandler(.failure(NetworkingError.fetchingError))
        } else {
            completionHandler(.success(WeatherProperties.init(cityName: "Cupertino", cityTemp: Main.init(temp: 20), weatherConditions: [Weather.init(id: 800, description: "sunny")]) as! T))
        }
    }
}


class WeatherTestCase: XCTestCase {

    func testGivenValidDataWhengetWeatherDataByCityThenReturnValidWeatherProperties() {
        //Given
        let repository = WeatherRepository(networking: MockNetworkingWeather(shouldReturnError: false))

        //When
        let expectation = self.expectation(description: "Get weather success")
        repository.getWeatherDataByCity(cityName: "Cupertino") { (result) in
            if case .success(let weatherProperties) = result {
                
                //Then
                XCTAssertEqual(weatherProperties.cityName, "Cupertino")
                XCTAssertEqual(weatherProperties.cityTemp.temp, 20)
                XCTAssertEqual(weatherProperties.weatherConditions[0].id, 800)
                XCTAssertEqual(weatherProperties.weatherConditions[0].description, "sunny")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGivenInValidDataWhengetWeatherDataByCityThenReturnError() {
        //Given
        let repository = WeatherRepository(networking: MockNetworkingWeather(shouldReturnError: true))

        //When
        let expectation = self.expectation(description: "Get weather failure")
        repository.getWeatherDataByCity(cityName: "Cupertino") { (result) in
            if case .failure(let error) = result {

                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.fetchingError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGivenValidDataWhengetWeatherDataByGpsThenReturnValidWeatherProperties() {
        //Given
        let repository = WeatherRepository(networking: MockNetworkingWeather(shouldReturnError: false))

        //When
        let expectation = self.expectation(description: "Get weather success")
        repository.getWeatherDataByGps(lat: "37", lon: "-122") { (result) in
            if case .success(let weatherProperties) = result {

                //Then
                XCTAssertEqual(weatherProperties.cityName, "Cupertino")
                XCTAssertEqual(weatherProperties.cityTemp.temp, 20)
                XCTAssertEqual(weatherProperties.weatherConditions[0].id, 800)
                XCTAssertEqual(weatherProperties.weatherConditions[0].description, "sunny")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGivenInValidDataWhengetWeatherDataByGpsThenReturnError() {
        //Given
        let repository = WeatherRepository(networking: MockNetworkingWeather(shouldReturnError: true))

        //When
        let expectation = self.expectation(description: "Get weather failure")
        repository.getWeatherDataByGps(lat: "37", lon: "-122") { (result) in
            if case .failure(let error) = result {

                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.fetchingError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }
}



