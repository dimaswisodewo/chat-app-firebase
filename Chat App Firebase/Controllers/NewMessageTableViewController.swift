//
//  NewMessageTableViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import UIKit
import FirebaseFirestore

class NewMessageTableViewController: UITableViewController {

    let cellId = "cellId"
    
    let db = Firestore.firestore()
    
    var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New message"
                
        // Setup bar button item
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(handleCancel))
        
        // Register cell
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: cellId)
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.isHidden = true
    }

    @objc private func handleCancel() {
        
        navigationController?.popViewController(animated: true)
    }
    
    private func fetchUsers() {
        
        guard let currentEmail = AuthManager.shared.currentUser?.email else { return }
        
        let ref = db.collection("users")
            .whereField("email", isNotEqualTo: currentEmail)
            .limit(to: 10)
        
        ref.getDocuments { [weak self] querySnapshot, error in
            
            guard let querySnapshot = querySnapshot else {
                print("Document does not exist")
                return
            }
            
            for document in querySnapshot.documents {
                
                let data = document.data()
                let user = UserModel(email: data["email"] as! String, name: data["name"] as! String)
                                
                self?.users.append(user)
            }
            
            self?.users = (self?.users.sorted { $0.name < $1.name })!
            
            print("Fetch users, count: \(querySnapshot.count)")
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? UserTableViewCell
        
        guard let cell = cell else { return UITableViewCell() }
        
        cell.tintColor = .label
        
        var contentConfig = cell.defaultContentConfiguration()
        
        contentConfig.text = users[indexPath.row].name
        contentConfig.secondaryText = users[indexPath.row].email
        contentConfig.textProperties.numberOfLines = 0
        contentConfig.textProperties.font = UIFont.boldSystemFont(ofSize: 20)
        contentConfig.secondaryTextProperties.numberOfLines = 0
        contentConfig.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        contentConfig.directionalLayoutMargins = .init(top: 20, leading: 14, bottom: 20, trailing: 14)
        contentConfig.textToSecondaryTextVerticalPadding = 10.0
        
        cell.contentConfiguration = contentConfig
                
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
