//
//  ErrorAlert.swift
//  Le Baluchon
//
//  Created by pith on 24/07/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import Foundation
import UIKit

struct ErrorAlert {

    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }

    static func showInvalidUrlAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Bad URL!", message: "Please enter a valide URL")
    }

    static func showUnableToFetchDataAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Failed to fecth Data", message: "Network error")
    }

    static func showCityNotFoundAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "City not found", message: "Please enter a known city")
    }

}


