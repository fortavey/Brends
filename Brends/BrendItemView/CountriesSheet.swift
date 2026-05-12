//
//  CountriesSheet.swift
//  Brends
//
//  Created by mm2 on 30.04.2026.
//

import SwiftUI

struct CountriesSheet: View {
    var viewModel: ContentViewModel
    @State private var countries: [Country] = []
    @State private var searchQuery: String = ""
    @Binding var countriesList: [String]
    var body: some View {
        TextField("Search", text: $searchQuery)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 20)
        HStack{
            List(searchFilter()){ country in
                if !countriesList.contains(country.code){
                    HStack{
                        Text(country.name)
                        Spacer()
                        Text(country.code)
                        Button(action: {
                            var newSet = Set(countriesList)
                            newSet.insert(country.code)
                            countriesList = Array(newSet)
                        }, label: {
                            Image(systemName: "plus")
                        })
                    }
                }
            }
        }
        .onAppear{
            if let countriesDict = viewModel.countriesDict {
                for (code, name) in countriesDict {
                    self.countries.append(Country(code: code, name: name))
                }
            }
        }
    }
    
    func searchFilter() -> [Country] {
        if searchQuery.isEmpty {
            return countries.sorted(by: { $0.name < $1.name })
        }else{
            return countries.filter{
                $0.name.lowercased().contains(searchQuery.lowercased())
                ||
                $0.code.lowercased().contains(searchQuery.lowercased())}
            .sorted(by: { $0.name < $1.name })
        }
    }
}
