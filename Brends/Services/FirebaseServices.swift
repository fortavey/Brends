//
//  FirebaseServices.swift
//  Brends
//
//  Created by Main on 18.12.2025.
//


import Foundation
import FirebaseFirestore
import SwiftUI


struct FirebaseServices {
    
    func getDocuments(collection: String, completion: @escaping ([QueryDocumentSnapshot]) -> Void){
        Firestore.firestore()
            .collection(collection)
            .getDocuments { snapshot, err in
                guard err == nil else {
                    print(err ?? "Ошибка получения списка документов")
                    return
                }
                guard let docs = snapshot?.documents else {return}
                
                completion(docs)
            }
    }
    
    func updateDocument(id: String, collection: String, fields: [AnyHashable : Any], completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection(collection)
            .document(id)
            .updateData(fields) { err in
                if err == nil {
                    completion(true)
                }else {
                    completion(false)
                }
                
            }
    }
    
    func removeDocument(id: String, collection: String, completion: @escaping (Bool) -> Void) {
        Firestore.firestore()
            .collection(collection)
            .document(id)
            .delete { err in
                if err == nil {
                    completion(true)
                }else {
                    completion(false)
                }
            }
    }
}


