//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by pith on 12/07/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    let translatedText = TranslateRepository(networking: NetworkingImplementation(networkingSession: URLSession.shared))

    @IBOutlet weak var toTranslate: UITextField!
    @IBOutlet weak var translationResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addingDoneButton()
        let test = Endpoint.currency.baseUrlString.isEmpty
        print("Je print mon test: \(test)")
    }

    // Adding a Done button in toolBar:
    func addingDoneButton() {

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: true)
        toTranslate.inputAccessoryView = toolBar
    }

    // Dissmissing keyboard when Done button clicked and call display result:
    @objc func doneClicked() {
        // Fetching for translation
        let textToTranslate = toTranslate.text!
        translatedText.getTranslation(text: textToTranslate) { (result) in
            switch result {
            case .success(let success):
                self.translationResult.text = success.data.translations[0].translatedText
            case .failure:
                ErrorAlert.showGenericAlert(on: self)
            }
        }
        view.endEditing(true)
    }
}
