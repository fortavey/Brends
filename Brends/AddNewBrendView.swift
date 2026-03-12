//
//  AddNewBrendView.swift
//  Brends
//
//  Created by Main on 14.01.2026.
//

import SwiftUI
import FirebaseFirestore

struct AddNewBrendView: View {
    var viewModel: ContentViewModel
    @State private var name: String = ""
    @State private var trackerLink: String = ""
    @State private var limitCounter = 5
    @State private var isFavorite = false
    @State private var isLocal = false
    
    var body: some View {
        Text("Добавить новый бренд")
            .font(.title)
        TextField("Бренд", text: $name)
            .padding(.horizontal, 30)
        TextField("Ссылка", text: $trackerLink)
            .padding(.horizontal, 30)
        HStack {
            TextField("Минимальное количество", value: $limitCounter, format: .number)
                .textFieldStyle(.roundedBorder)
            
            Stepper("", value: $limitCounter, in: 0...15, step: 1)
                .labelsHidden()
            Spacer()
        }
        .padding(.horizontal, 30)
        HStack{
            Toggle("Основа", isOn: $isFavorite)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
            Toggle("Локальный", isOn: $isLocal)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
            Spacer()
        }
        
        Button("Добавить"){
            addNewBrend()
        }
        
        Spacer()
    }
    
    private func resetAll(){
        name = ""
        trackerLink = ""
        limitCounter = 5
        isFavorite = false
        isLocal = false
    }
    
    private func addNewBrend(){
        Firestore.firestore()
            .collection("brends")
            .document()
            .setData([
                "name": name,
                "trackerLink": trackerLink,
                "limitCounter": limitCounter,
                "isFavorite": isFavorite,
                "isLocal": isLocal
            ], merge: true) { err in
                if err == nil {
                    print("Saved")
                    viewModel.getBrendsList()
                    resetAll()
                }else{
                    print("ERR")
                }
            }
    }
}
