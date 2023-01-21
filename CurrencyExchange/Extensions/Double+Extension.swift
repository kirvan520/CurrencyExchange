//
//  Double+Extension.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//

import Foundation

extension Double {
    var amountInStringFormat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencySymbol = ""
        return formatter.string(from: NSNumber(value: self)) ?? "0.00"
    }
}
