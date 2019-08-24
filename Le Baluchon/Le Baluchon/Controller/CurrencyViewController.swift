//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by pith on 03/06/2019.
//  Copyright © 2019 dino. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {

    // Dependency Injection:
    let currencyRepository = CurrencyRepository(networking: Networking())

    var currencyDict = [String: Float]()
    var currencySymbol = [String]()
    var currencyValueInDollar: Float = 0

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {

        super.viewDidLoad()

        addingDoneButton()

        // Setting PickerView:
        currencyPicker.delegate = self
        currencyPicker.dataSource = self

        currencyRepository.getCurrency { (result) in
            switch result {
            case .success(let currency):
                self.updatePickerView(currencyProperties: currency)
                self.currencyDict = currency.rates
            case .failure:
                ErrorAlert.showGenericAlert(on: self)
            }

            // Display first row currency calculation
            if let selectedCurrency = self.currencySymbol.first {
                self.convertCurrencyInDollars(currencySymbol: selectedCurrency)
            }
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
        updateLabel(currencyValueInDollar: currencyValueInDollar)
        view.endEditing(true)
    }

    // Mapping currencyDict in order to have the currency alphabeticaly sorted:
    func updatePickerView(currencyProperties: CurrencyProperties) {

        let keysFromDictionary = currencyProperties.rates.keys.map({$0})
        let mySortedArray = keysFromDictionary.sorted(by: <)
        self.currencySymbol = mySortedArray
        self.currencyPicker.reloadAllComponents()
    }

    func convertCurrencyInDollars(currencySymbol: String) {

        guard let currencyValueVsEuro = currencyDict[currencySymbol] else {
            return
        }
        guard let dollarValueVsEuro = currencyDict["USD"] else {
            return
        }
        currencyValueInDollar = (dollarValueVsEuro/currencyValueVsEuro)
        updateLabel(currencyValueInDollar: currencyValueInDollar)
    }

    func updateLabel(currencyValueInDollar: Float) {
        let inputTextField = textField.text
        print("\(currencyValueInDollar) is the corresponding value in Dollar")
        let valueToDisplay = String((inputTextField! as NSString).floatValue * currencyValueInDollar)
        resultLabel.text = valueToDisplay
    }
}

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencySymbol.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencySymbol[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let selectedCurrency = currencySymbol[row]
        convertCurrencyInDollars(currencySymbol: selectedCurrency)
    }
}

