//
//  CountryItem.swift
//  Brends
//
//  Created by mm2 on 30.04.2026.
//

import SwiftUI

struct CountryItemView: View {
    @Binding var countries: [String]
    @State private var isHovered: Bool = false
    var code: String
    var countryName: String
    
    var body: some View {
        Button(action: {
            countries = countries.filter({$0 != code})
        }, label: {
            Text(code)
            Image(systemName: "xmark.circle")
                .foregroundColor(.red)
        })
        .onHover { hover in
            isHovered = hover ? true : false
        }
        .popover(isPresented: $isHovered) {
            Text(countryName)
                .padding()
        }
    }
}
