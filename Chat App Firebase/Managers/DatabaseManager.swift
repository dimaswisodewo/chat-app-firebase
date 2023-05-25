//
//  DatabaseManager.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore()
}
