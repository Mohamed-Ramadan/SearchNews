//
//  Constants.swift
//  SearchNews
//
//  Created by Mohamed Ramadan on 24/09/2021.
//

import Foundation

class Constants {
    // https://newsapi.org/v2/everything?q=apple&apiKey=6ffb166ac19245adbc4f31cac16061e1
    static let serverURl = "http://newsapi.org/v2/everything?"
    static let apiKey = "6ffb166ac19245adbc4f31cac16061e1" 
}

enum HTTPMethod: String {
    case get = "GET"
}
