//
//  BrendModel.swift
//  Brends
//
//  Created by Main on 18.12.2025.
//

import Foundation

struct CountryModel: Identifiable {
    var id: String
    var code: String
    var languages: [String]
}

struct BrendModel: Identifiable {
    var id: String
    var name: String
    var trackerLink: String
    var сountries: [String]
    var languages: [String]
    var isFavorite: Bool
}
