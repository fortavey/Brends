//
//  ContentView.swift
//  Brends
//
//  Created by Main on 18.12.2025.
//

import SwiftUI

struct Buttonnn: View {
    var body: some View {
        Button("CLICK"){
            if let dict = Bundle.main.infoDictionary?["Countries"] as? [String: String] {
                for (key, value) in dict {
                    print("Ключ: \(key), Значение: \(value)")
                }
            }
        }
    }
}

struct ContentView: View {
    @State private var brendsList: [BrendModel] = []
    @State private var searchText: String = ""
    @State private var showingAddNewBrendSheet = false
    
    var body: some View {
        NavigationSplitView {
            if brendsList.isEmpty {
                Button("Сформировать"){
                    getBrendsList()
                }
            }else {
                VStack{
                    List(sortBrendsList()) { brend in
                        NavigationLink(brend.name, destination: Buttonnn())
                        if sortBrendsList().last?.name == brend.name {
                            Spacer()
                            NavigationLink("Добавить", destination: AddNewBrendView())
                            NavigationLink("Страны", destination: CountriesView())
                        }
                    }
                }
                
            }
        } detail: {
            ContentUnavailableView("Select an element from the sidebar", systemImage: "doc.text.image.fill")
        }
        .searchable(text: $searchText, placement: .sidebar)
    }
    
    func sortBrendsList() -> [BrendModel]{
        if searchText.isEmpty {
            return brendsList.sorted { $0.name < $1.name }
        }else {
            return brendsList.sorted { $0.name < $1.name }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func getBrendsList(){
        FirebaseServices().getDocuments(collection: "brends") { docs in
            var array: [BrendModel] = []
            
            docs.forEach{doc in
                let id = doc.documentID
                let name = doc["name"] as? String
                let trackerLink = doc["trackerLink"] as? String
                let countries = doc["countries"] as? [String]
                let languages = doc["languages"] as? [String]
                let isFavorite = doc["isFavorite"] as? Bool
                
                array.append(
                    BrendModel(
                        id: id,
                        name: name ?? "",
                        trackerLink: trackerLink ?? "",
                        сountries: countries ?? [],
                        languages: languages ?? [],
                        isFavorite: isFavorite ?? false
                    )
                )
            }
            self.brendsList = array
        }
    }
    
}
