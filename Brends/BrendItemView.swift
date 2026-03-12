//
//  BrendItemView.swift
//  Brends
//
//  Created by mm2 on 11.03.2026.
//

import SwiftUI
import FirebaseFirestore

struct BrendItemView: View {
    var brend: BrendModel
    var viewModel: ContentViewModel
    @State private var name: String
    @State private var trackerLink: String
    @State private var limitCounter: Int
    @State private var isFavorite: Bool
    @State private var isLocal: Bool
    @State private var isChangeName:Bool = false
    
    init(brend: BrendModel, viewModel: ContentViewModel) {
        self.viewModel = viewModel
        self.brend = brend
        self.name = brend.name
        self.trackerLink = brend.trackerLink
        self.limitCounter = brend.limitCounter
        self.isFavorite = brend.isFavorite
        self.isLocal = brend.isLocal
    }
    
    var body: some View {
        Text(name)
            .font(.title)
        HStack{
            TextField("Бренд", text: $name)
                .padding(.horizontal, 30)
                .disabled(!isChangeName)
            Button("Изменить"){
                isChangeName.toggle()
            }
            .padding(.horizontal, 30)
        }
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
        
        Button("Сохранить"){
            updateBrend()
        }
        
        Spacer()
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
                                            "limitCounter": limitCounter,
                                            "isFavorite": isFavorite,
                                            "isLocal": isLocal,
                                          ]) { result in
            if result {
                viewModel.getBrendsList()
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
