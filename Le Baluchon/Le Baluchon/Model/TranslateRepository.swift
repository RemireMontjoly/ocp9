//
//  TranslateRepository.swift
//  Le Baluchon
//
//  Created by pith on 02/08/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation

struct TranslationResponse: Decodable {
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

    private let networking: Networking
    init(networking: Networking) {
        self.networking = networking
    }

    func getTranslation(text: String, completion: @escaping (Result<TranslationResponse, Error>) -> ()) {

        networking.request(endpoint: Endpoint.translation(myText: text).url ) { (result: Result<TranslationResponse, Error>) in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
