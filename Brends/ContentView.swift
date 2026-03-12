//
//  ContentView.swift
//  Brends
//
//  Created by Main on 18.12.2025.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    @State private var searchText: String = ""
    @State private var showingAddNewBrendSheet = false
    
    var body: some View {
        NavigationSplitView {
            if viewModel.brendsList.isEmpty {
                Button("Сформировать"){
                    viewModel.getBrendsList()
                }
            }else {
                VStack{
                    List(sortBrendsList()) { brend in
                        NavigationLink(brend.name, destination: BrendItemView(brend: brend, viewModel: viewModel).id(brend.id))
                        if sortBrendsList().last?.name == brend.name {
                            Spacer()
                            NavigationLink("Добавить", destination: AddNewBrendView(viewModel: viewModel))
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
            return viewModel.brendsList.sorted { $0.name < $1.name }
        }else {
            return viewModel.brendsList.sorted { $0.name < $1.name }.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}
