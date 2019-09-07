//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by pith on 12/07/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    let translatedText = TranslateRepository(networking: NetworkingImplementation())

    @IBOutlet weak var toTranslate: UITextField!
    
    @IBOutlet weak var translationResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addingDoneButton()
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

                print(self.translationResult.text!)

            case .failure(let error):
                //Pop up
                print(error)
            }
        }
        view.endEditing(true)
    }
    
}
