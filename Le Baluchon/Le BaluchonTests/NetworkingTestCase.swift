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
    func testRequestShouldPostFailureCallbackIfBadUrl() {
        //Given
        let corruptedUrl = URL(string: "éé")
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: nil, error: nil))

        //When
        networkingImplementation.request(endpoint: corruptedUrl) { (result:Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.invalideUrl)
            }
        }
    }

    func testRequestShouldPostFailureCallbackIfError() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))

        //When
        let expectation = self.expectation(description: "Get error")
        networkingImplementation.request(endpoint: Endpoint.currency.url) { (result:  Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.fetchingError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.01)
    }

    func testRequestShouldPostFailureCallbackIfStatusCodeIs404() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: nil, response: FakeResponseData.responseFailure, error: nil))

        //When
        let expectation = self.expectation(description: "Get response error 404")
        networkingImplementation.request(endpoint: Endpoint.currency.url) { (result:  Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.invalidCityName)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.01)
    }

    func testRequestShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: FakeResponseData.currencyData, response: nil, error: nil))

        //When
        let expectation = self.expectation(description: "Get correct data")
        networkingImplementation.request(endpoint: Endpoint.currency.url) { (result:  Result<CurrencyProperties, Error>) in
            if case .success(let success) = result {
                //Then
                let fakeRates = ["AED": 4.044198,"AFN": 85.827195,"ALL": 122.271908]
                //  let transform =  Double(fakeRates)
                XCTAssertEqual(success.rates, fakeRates)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.01)
    }

    func testRequestShouldPostFailureCallbackIfCorruptedData() {
        //Given
        let networkingImplementation = NetworkingImplementation(networkingSession: URLSessionFake(data: FakeResponseData.corruptedData, response: nil, error: nil))
        
        //When
        let expectation = self.expectation(description: "Get decode data error")
        networkingImplementation.request(endpoint: Endpoint.currency.url) { (result: Result<CurrencyProperties, Error>) in
            if case .failure(let error) = result {
                //Then
                XCTAssertTrue(error is NetworkingError)
                XCTAssertEqual(error as! NetworkingError, NetworkingError.decodeJsonError)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.01)
    }
}


