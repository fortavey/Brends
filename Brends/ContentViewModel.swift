//
//  ContentViewModel.swift
//  Brends
//
//  Created by mm2 on 11.03.2026.
//

import Foundation
import Combine

@Observable
class ContentViewModel {
    var brendsList: [BrendModel] = []
    
    func getBrendsList(){
        FirebaseServices().getDocuments(collection: "brends") { docs in
            var array: [BrendModel] = []
            
            docs.forEach{doc in
                let id = doc.documentID
                let name = doc["name"] as? String
                let trackerLink = doc["trackerLink"] as? String
                let countries = doc["countries"] as? [String]
                let languages = doc["languages"] as? [String]
                let limitCounter = doc["limitCounter"] as? Int
                let isFavorite = doc["isFavorite"] as? Bool
                let isLocal = doc["isLocal"] as? Bool
                
                array.append(
                    BrendModel(
                        id: id,
                        name: name ?? "",
                        trackerLink: trackerLink ?? "",
                        сountries: countries ?? [],
                        languages: languages ?? [],
                        isFavorite: isFavorite ?? false,
                        isLocal: isLocal ?? false,
                        limitCounter: limitCounter ?? 5
                    )
                )
            }
            self.brendsList = array
        }
    }
}
