//
//  TranslationTestCase.swift
//  Le BaluchonTests
//
//  Created by pith on 01/10/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import XCTest
@testable import Le_Baluchon

class MockNetworkingTranslation: Networking {
    var shouldReturnError = true

    init(shouldReturnError: Bool) {
        self.shouldReturnError = shouldReturnError
    }
    func request<T>(endpoint: URL?, completionHandler: @escaping (Result<T, Error>) -> ()) where T : Decodable {
        if shouldReturnError {
            completionHandler(.failure(NetworkingError.fetchingError))
        } else {
            completionHandler(.success(TranslationResponse.init(data: Translations.init(translations: [TranslatedText.init(translatedText: "Hello", detectedSourceLanguage: "fr")])) as! T))
        }
    }
}

class TranslationTestCase: XCTestCase {

    func testGivenValidDataWhenGetTranslationThenReturnValidTranslationResponse() {
        //Given
        let repository = TranslateRepository(networking: MockNetworkingTranslation(shouldReturnError: false))

        //When
        let expectation = self.expectation(description: "Get translation success")
        repository.getTranslation(text: "Bonjour") { result in
            if case .success(let translation) = result {
                //Then

                XCTAssertEqual(translation.data.translations[0].translatedText, "Hello")
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func testGivenInvalidDataWhenGetTranslationThenReturnError() {
        //Given
        let repository = TranslateRepository(networking: MockNetworkingTranslation(shouldReturnError: true))

        //When
        let expectation = self.expectation(description: "Get translation failure")
        repository.getTranslation(text: "Bonjour") { result in
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
