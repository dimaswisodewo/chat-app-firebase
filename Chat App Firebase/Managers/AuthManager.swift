//
//  AuthManager.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    var currentUser: User? {
        get { Auth.auth().currentUser }
    }
            
    func getCurrentUser(completion: @escaping (UserModel?) -> Void ) {
        
        guard let currentUser = Auth.auth().currentUser else {
            
            print("Failed to get current user!")
            return
        }
        
        let ref = DatabaseManager.shared.db.collection("users")
        let docRef = ref.document(currentUser.uid)
                
        docRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                
                let data = document.data()
                let email = data?["email"] as? String ?? "-"
                let name = data?["name"] as? String ?? "-"
                
                print("Current user email: \(email), name: \(name)")
                let user = UserModel(email: email, name: name)
                completion(user)
                
            } else {
                
                print("Document does not exist")
                completion(nil)
            }
        }
    }
}
