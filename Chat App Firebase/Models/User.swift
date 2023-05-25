//
//  User.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import Foundation

class User {
        
    init(email: String, name: String) {
        self.email = email
        self.name = name
    }
    
    let email: String
    let name: String
}
