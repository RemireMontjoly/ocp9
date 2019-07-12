//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by pith on 03/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    let currency = CurrencyRepository(networking: Networking())

    var currencyArray = [String]()
    var currencySymbol = [String]()
    var currencyValue = [Int]()

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        currency.getCurrency { (currency) in
            print(currency)
            self.currencyArray += currency.rates.keys.map({$0})
        }
    }
}

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
}


