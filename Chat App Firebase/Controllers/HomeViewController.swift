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
                
        view.tintColor = .label
        view.backgroundColor = .systemBackground
        
        setupBarButtonItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupBarButtonItems() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed) )
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(handleNewMessage))
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

