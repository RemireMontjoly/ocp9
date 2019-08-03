//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by pith on 12/07/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit

class TranslateViewController: UIViewController {

    let translatedText = TranslateRepository(networking: Networking())

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addingDoneButton()
        translatedText.getTranslation { (result) in
            print(result)
        }
    }

    // Adding a Done button in toolBar:
    func addingDoneButton() {

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([doneButton], animated: true)
        textField.inputAccessoryView = toolBar
    }

    // Dissmissing keyboard when Done button clicked and display result:
    @objc func doneClicked() {
        //updateLabel
        view.endEditing(true)
    }


}
