//
//  ProfileViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 25/05/23.
//

import UIKit

class ProfileViewController: UIViewController {

    private let profileImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        view.layer.borderWidth = 2.0
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "profile")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.text = "-"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.text = "-"
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground

        view.addSubview(profileImageContainer)
        view.addSubview(nameLabel)
        view.addSubview(emailLabel)
        
        profileImageContainer.addSubview(profileImageView)
        
        setupProfileImageView()
        setupLabel()
        
        AuthManager.shared.getCurrentUser { [weak self] user in
            
            guard let user = user else { return }
            
            self?.nameLabel.text = user.name
            self?.emailLabel.text = user.email
        }
    }
    
    override func viewDidLayoutSubviews() {
        
        profileImageContainer.layer.cornerRadius = profileImageContainer.bounds.size.width / 2
    }
    
    private func setupProfileImageView() {
        
        profileImageContainer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        profileImageContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2).isActive = true
        profileImageContainer.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2).isActive = true
        profileImageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: profileImageContainer.topAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: profileImageContainer.leftAnchor).isActive = true
        profileImageView.rightAnchor.constraint(equalTo: profileImageContainer.rightAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: profileImageContainer.bottomAnchor).isActive = true
    }

    private func setupLabel() {
        
        nameLabel.topAnchor.constraint(equalTo: profileImageContainer.bottomAnchor, constant: 50).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 14).isActive = true
        emailLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}
