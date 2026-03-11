//
//  CountriesView.swift
//  Brends
//
//  Created by Main on 09.02.2026.
//

import SwiftUI

struct CountryItem {
    var name: String
    var code: String
}

struct CountriesView: View {
    @State private var countriesList: [CountryItem] = []
    @State private var selection: String?
    var body: some View {
        List(countriesList.sorted(by: {$0.name < $1.name}), id: \.code, selection: $selection) { country in
            HStack{
                Text(country.code)
                Text(country.name)
            }
        }
        .onAppear{
            if let countries = Bundle.main.object(forInfoDictionaryKey: "Countries") as? [String: String] {
                countries.forEach{key, value in
                    countriesList.append(CountryItem(name: value, code: key))
                }
            }
        }
    }
        
}
