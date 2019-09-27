//
//  FakeResponseData.swift
//  Le BaluchonTests
//
//  Created by pith on 31/08/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation



class FakeResponseData {

    // MARK : - Response
    static let responseSuccess = HTTPURLResponse(
        url: URL(string: "https://monSite.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    static let responseFailure = HTTPURLResponse(
        url: URL(string: "https://monSite.com")!,
        statusCode: 404, httpVersion: nil, headerFields: nil)!

    // MARK : - Error
    class CurrencyError: Error {}
    static let error = CurrencyError()

    // MARK : - Data
    static var currencyData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Currency", withExtension: "json")!
        return try! Data(contentsOf: url)
    }

    static let corruptedData = "corrupted".data(using: .utf8)
}
