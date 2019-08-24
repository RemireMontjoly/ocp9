//
//  TranslateRepository.swift
//  Le Baluchon
//
//  Created by pith on 02/08/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

struct Data: Decodable {
    let data: Translations
}

struct Translations: Decodable {
    let translations: [TranslatedText]
}

struct TranslatedText: Decodable {
    let translatedText: String
    let detectedSourceLanguage: String
}

class TranslateRepository {

    let networking: ApiRequest
    init(networking: ApiRequest) {
        self.networking = networking
    }

    func getTranslation(text: String, completion: @escaping (Result<Data, Error>) -> ()) {

        networking.request(endpoint: Endpoint.translation(myText: text) ) { (result: Result<Data, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
