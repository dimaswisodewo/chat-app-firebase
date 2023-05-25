//
//  ViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 04/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.tintColor = .label
        view.backgroundColor = .systemBackground
        
        setupBarButtonItems()
        
        getUserData()
    }
    
    private func setupBarButtonItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logoutPressed) )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
      
    private func getUserData() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            
            print("uid of current user is not found")
            return
        }
        
        let ref = self.db.collection("users")
        let docRef = ref.document(uid)
        
        docRef.getDocument { document, error in
            
            if let document = document, document.exists {
                
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func logoutPressed() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error logout: \(String(describing: error))")
        }
        
        self.view.window?.rootViewController = LoginViewController()
    }
    
    @objc private func handleNewMessage() {
                
        let newMessageVC = NewMessageTableViewController()
        navigationController?.pushViewController(newMessageVC, animated: true)
    }
    
}

