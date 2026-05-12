//
//  BrendItemView.swift
//  Brends
//
//  Created by mm2 on 11.03.2026.
//

import SwiftUI
import FirebaseFirestore

struct Country: Identifiable {
    var id = UUID()
    var code: String
    var name: String
}

struct BrendItemView: View {
    var brend: BrendModel
    var viewModel: ContentViewModel
    @State private var countries: [String]
    @State private var isActiveChanges: Bool = false
    @State private var name: String
    @State private var trackerLink: String
    @State private var creoLink: String
    @State private var limitCounter: Int
    @State private var isFavorite: Bool
    @State private var isPaused: Bool
    @State private var isLocal: Bool
    @State private var isChangeName:Bool = false
    @State private var isCountryesList:Bool = false
    
    init(brend: BrendModel, viewModel: ContentViewModel) {
        self.viewModel = viewModel
        self.brend = brend
        self.name = brend.name
        self.trackerLink = brend.trackerLink
        self.creoLink = brend.creoLink
        self.limitCounter = brend.limitCounter
        self.isFavorite = brend.isFavorite
        self.isPaused = brend.isPaused
        self.isLocal = brend.isLocal
        self.countries = brend.countries
    }
    
    var body: some View {
        Text(name)
            .font(.title)
        HStack{
            Button{
                let pasteboard = NSPasteboard.general
                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                pasteboard.setString(name, forType: .string)
            }label: {
                Image(systemName: "doc.on.doc")
            }
            TextField("Бренд", text: $name)
                .padding(.horizontal, 30)
                .disabled(!isChangeName)
            Button("Изменить"){
                isChangeName.toggle()
            }
        }
        .padding(.horizontal, 30)
        
        TextField("Ссылка", text: $trackerLink)
            .padding(.horizontal, 30)
            .onChange(of: trackerLink) { (old, new) in
                isActiveChanges = true
            }
        TextField("Ссылка на креативы", text: $creoLink)
            .padding(.horizontal, 30)
            .onChange(of: creoLink) { (old, new) in
                isActiveChanges = true
            }
        HStack {
            Text("Кластер")
                .font(.title2)
            ForEach(1...15, id: \.self) { cluster in
                if limitCounter == cluster {
                    Button("\(cluster)"){
                        limitCounter = cluster
                    }
                    .buttonStyle(.borderedProminent)
                }else {
                    Button("\(cluster)"){
                        limitCounter = cluster
                    }
                }
            }
            Spacer()
        }
        .onChange(of: limitCounter) { (old, new) in
            isActiveChanges = true
        }
        .padding(30)
        HStack{
            Toggle("Основа", isOn: $isFavorite)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
                .onChange(of: isFavorite) { (old, new) in
                    isActiveChanges = true
                }
            Toggle("Локальный", isOn: $isLocal)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
                .onChange(of: isLocal) { (old, new) in
                    isActiveChanges = true
                }
            Toggle("На паузе", isOn: $isPaused)
                .toggleStyle(.switch)
                .tint(.green)
                .padding(.horizontal, 30)
                .onChange(of: isPaused) { (old, new) in
                    isActiveChanges = true
                }
            Spacer()
        }
        
        if isActiveChanges {
            Button("Сохранить"){
                updateBrend()
            }
        }
        
        VStack{
            HStack{
                Text("Страны")
                    .font(.title2)
                    .padding(.top, 20)
                    .onChange(of: countries) { (old, new) in
                        isActiveChanges = true
                    }
                Spacer()
            }
            if !countries.isEmpty {
                HStack{
                    ForEach(countries, id: \.self){ code in
                        HStack{
                            CountryItemView(countries: $countries, code: code, countryName: viewModel.countriesDict![code] ?? "Страна")
                        }
                    }
                    Spacer()
                }
                
            }
            Button(action: {
                isCountryesList.toggle()
            }, label: {
                Image(systemName: isCountryesList ? "minus" : "plus")
            })
        }
        .padding(.horizontal, 30)
        
        if isCountryesList {
            CountriesSheet(viewModel: viewModel, countriesList: $countries)
        }else {
            Spacer()
        }
        
        Button("Удалить"){
            removeBrend()
        }
    }
    
    private func updateBrend(){
        FirebaseServices().updateDocument(id: brend.id,
                                          collection: "brends",
                                          fields: [
                                            "name" : name,
                                            "trackerLink": trackerLink,
                                            "creoLink": creoLink,
                                            "limitCounter": limitCounter,
                                            "isFavorite": isFavorite,
                                            "isPaused": isPaused,
                                            "isLocal": isLocal,
                                            "countries": Array(countries)
                                          ]) { result in
                                              if result {
                                                  viewModel.getBrendsList()
                                                  isActiveChanges = false
                                              }else {
                                                  print("Ошибка обновления")
                                                  
                                              }
                                          }
    }
    
    private func removeBrend(){
        Firestore.firestore()
            .collection("brends")
            .document(brend.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    viewModel.getBrendsList()
                }
            }
    }
}
