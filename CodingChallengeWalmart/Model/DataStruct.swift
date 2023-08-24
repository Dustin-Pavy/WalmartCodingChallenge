//
//  DataStruct.swift
//  CodingChallengeWalmart
//
//  Created by Dustin Pavy on 8/23/23.
//

import Foundation

// MARK: - CountryElement
struct CountryElement: Codable {
    let capital: String
    let currency: Currency
    let flag: String
    let language: Language
    let code: String
    let name: String
    let region: Region
    let demonym: String?
}

// MARK: - Currency
struct Currency: Codable {
    let code: String
    let name: String
    let symbol: String?
}

// MARK: - Language
struct Language: Codable {
    let code: String?
    let name: String
    let iso6392, nativeName: String?

    enum CodingKeys: String, CodingKey {
        case code, name
        case iso6392 = "iso639_2"
        case nativeName
    }
}

enum Region: String, Codable {
    case af = "AF"
    case americas = "Americas"
    case an = "AN"
    case empty = ""
    case eu = "EU"
    case na = "NA"
    case oc = "OC"
    case regionAS = "AS"
    case sa = "SA"
}

typealias Country = [CountryElement]

extension CountryElement{
    static func mockCountryList() -> [CountryElement]{
        return [CountryElement(
            capital: "Pago Pago",
            currency: Currency(code: "USD", name: "United State Dollar", symbol: "$"),
            flag: "https://restcountries.eu/data/asm.svg",
            language: Language(code: "en", name: "English", iso6392: "", nativeName: ""),
            code: "AS",
            name: "American Samoa",
            region: Region(rawValue: "OC")!,
            demonym: ""
        )]
    }
    
}
