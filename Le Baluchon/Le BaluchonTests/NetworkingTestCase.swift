//
//  NetworkingTestCase.swift
//  Le BaluchonTests
//
//  Created by pith on 31/08/2019.
//  Copyright © 2019 dino. All rights reserved.
//
import Foundation
import XCTest
@testable import Le_Baluchon

// MARK: - NetworkingImplementation tests:

class NetworkingImplementationTestCase: XCTestCase {

    // test que le Networking ne renvoi pas badUrl
    func testRequestShouldNeverFailWithEndpoint() {
        //tous les Endpoint

        let endpoint = Endpoint.currency.url
        XCTAssertNotNil(endpoint)
    }

//    func testRequestShouldPostFailureCallbackIfBadUrl() {
//        //Given
//        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: nil, error: nil))
//        // let endpoint = Endpoint.weatherLoc(lat: "é  ", lon: " à")
//        let endpointTest = Endpoint.test // Trying to send a bad URL...
//
//        //When
//        networkingImplementation.request(endpoint: endpointTest) {(result: Result<CurrencyProperties, Error>) in
//            if case .failure(let error) = result {
//                //Then
//                XCTAssertTrue(error is NetworkingError)
//                XCTAssertEqual(error as! NetworkingError, NetworkingError.invalideUrl)
//            }
//        }
//    }

    func testRequestShouldPostFailureCallbackIfError() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        //When
        networkingImplementation.request(endpoint: Endpoint.currency) { (result:  Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.fetchingError)
            }
        }
    }

    func testRequestShouldPostFailureCallbackIfStatusCodeIs404() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: FakeResponseData.responseFailure, error: nil))

        //When
        networkingImplementation.request(endpoint: Endpoint.currency) { (result:  Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidCityName)
            }
        }
    }

    func testRequestShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: FakeResponseData.currencyData, response: nil, error: nil))
        //When
        networkingImplementation.request(endpoint: Endpoint.currency) { (result:  Result<CurrencyProperties, Error>) in
            if case .success(let success) = result {
                //Then
                let fakeRates = ["AED": 4.044198,"AFN": 85.827195,"ALL": 122.271908]
                //  let transform =  Double(fakeRates)
                XCTAssertEqual(success.rates, fakeRates)
            }
        }
    }

    func testRequestShouldPostFailureCallbackIfCorruptedData() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: FakeResponseData.corruptedData, response: nil, error: nil))
        //When
        networkingImplementation.request(endpoint: Endpoint.currency) { (result: Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.decodeJsonError)
            }
        }
    }
}


