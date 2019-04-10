//
//  ViewController.swift
//  CryptoPriceTracker
//
//  Created by apple on 4/10/19.
//  Copyright © 2019 shivaapple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyData: [(name:String,symbol:String)] = [ ("AUD",  "$"), ("BRL","R$") ,("CAD","$"), ("CNY" , "¥"), ("EUR" , "€"), ("GBP" , "£"), ("HKD" , "$"), ("IDR" , "Rp"), ("ILS" , "₪"), ("INR",  "₹"), ("JPY" , "¥"), ("MXN" , "$"), ("NOK" , "kr"), ("NZD" , "$"), ("PLN" , "zł"), ("RON" , "lei"), ("RUB" , "₽"), ("SEK" , "kr"), ("SGD" , "$"), ("USD" , "$"), ("ZAR" , "R") ]
   
    var finalURL = ""
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getCryptoPrice(currency:currencyData[row].name,symbol: currencyData[row].symbol)
    }
    
    func getCryptoPrice(currency:String,symbol : String) {
        finalURL = baseURL + currency
        print(finalURL)
        Alamofire.request(finalURL, method:.get).responseJSON {
            response in
            if response.result.isSuccess {
                let price : JSON = JSON(response.result.value)
                self.updatePriceData(json : price,symbol: symbol)
            }else{
                self.priceLabel.text = "Connection Not Available"
            }
        }
    }
    
    func updatePriceData(json : JSON, symbol: String){
            priceLabel.text = json["last"].stringValue + symbol
    }
    
}

