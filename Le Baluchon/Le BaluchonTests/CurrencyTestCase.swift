//
//  CurrencyTestCase.swift
//  Le BaluchonTests
//
//  Created by pith on 13/09/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class MockNetworking: Networking {
    var shouldReturnError = true

    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    func request<T>(endpoint: Endpoint, completionHandler: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        if shouldReturnError {
            completionHandler(.failure(NetworkingError.fetchingError))
        } else {
            completionHandler(.success(CurrencyProperties.init(rates: ["" : 0.9]) as! T))
        }
    }
}

class CurrencyTestCase: XCTestCase {

    func testGivenValidDataWhenGetCurrencyThenReturnValidcurrencyProperties() {
        //Given
        let repository = CurrencyRepository(networking: MockNetworking(shouldReturnError: false))

        //When
        let expectation = self.expectation(description: "Get currency success")
        repository.getCurrency { (result) in
            if case .success(let currencyProperties) = result {
                //Then
                XCTAssertEqual(currencyProperties.rates, ["": 0.9])
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGivenInvalidDataWhenGetCurrencyThenReturnError() {
        //Given
        let repository = CurrencyRepository(networking: MockNetworking(shouldReturnError: true))

        //When
        let expectation = self.expectation(description: "Get currency failure")
        repository.getCurrency { (result) in
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
