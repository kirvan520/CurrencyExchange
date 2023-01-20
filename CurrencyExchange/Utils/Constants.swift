//
//  Constants.swift
//  CurrencyExchange
//
//  Created by Kiran on 1/20/23.
//


// API loading status

enum APIState {
    case isLoading
    case isFinished
    case failed(APIError)
}
