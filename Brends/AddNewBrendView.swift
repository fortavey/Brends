//
//  AddNewBrendView.swift
//  Brends
//
//  Created by Main on 14.01.2026.
//

import SwiftUI

struct AddNewBrendView: View {
    @State private var name: String = ""
    @State private var trackerLink: String = ""
    @State private var isFavorite = false
    
    var body: some View {
        Text("Добавить новый бренд")
            .font(.title)
        TextField("Бренд", text: $name)
            .padding(.horizontal, 30)
        TextField("Ссылка", text: $trackerLink)
            .padding(.horizontal, 30)
        HStack{
            Toggle("Основа", isOn: $isFavorite)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
            Spacer()
        }
        
        Spacer()
    }
}
