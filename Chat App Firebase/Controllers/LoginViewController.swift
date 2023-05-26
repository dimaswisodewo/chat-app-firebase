//
//  LoginViewController.swift
//  Chat App Firebase
//
//  Created by Dimas Wisodewo on 04/05/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    private let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161, a: 1)
        button.layer.cornerRadius = 20
        button.layer.cornerCurve = .continuous
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.autocapitalizationType = .none
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.autocapitalizationType = .none
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220, a: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.setTitleTextAttributes([.backgroundColor: UIColor(r: 80, g: 101, b: 161, a: 1)], for: .normal)
        sc.setTitleTextAttributes([.foregroundColor: UIColor(r: 80, g: 101, b: 161, a: 1)], for: .selected)
        sc.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        sc.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        sc.layer.borderWidth = 1.0
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var inputsContainerHeightConstraint: NSLayoutConstraint?
    private var nameTextFieldHeightConstraint: NSLayoutConstraint?
    private var emailTextFieldHeightContraint: NSLayoutConstraint?
    private var passwordTextFieldHeightConstraint: NSLayoutConstraint?
    
    private let textFieldsheight: CGFloat = 180
    
    let db = Firestore.firestore()
    
    private let loadingViewController = LoadingViewController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151, a: 1)
        
        view.addSubview(inputsContainerView)
        view.addSubview(registerButton)
        view.addSubview(logoImageContainer)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(errorLabel)
        
        setupInputsContainerView()
        setupRegisterButton()
        setupLogoImage()
        setupLoginRegisterSegmentedControl()
        setupLoadingView()
    }
    
    override func viewDidLayoutSubviews() {
        
        // Make logo image container circle
        logoImageContainer.layer.cornerRadius = logoImageContainer.bounds.height / 2
    }
    
    private func setupLoadingView() {
        
        loadingViewController.modalPresentationStyle = .overCurrentContext
        loadingViewController.modalTransitionStyle = .crossDissolve
    }
    
    private func setLoading(_ isActive: Bool) {
        
        if (isActive) {
            present(loadingViewController, animated: true)
        } else {
            loadingViewController.dismiss(animated: true)
        }
    }
    
    private func setErrorLabel(isHidden: Bool, errorMessage: String? = nil) {
        
        errorLabel.text = errorMessage
        errorLabel.isHidden = isHidden
        
        // Play error label animation
        if !isHidden {
            
            // Play animation after 0.01 sec delay
            let animDelay = 0.01
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animDelay, execute: { [weak self] () -> Void in
                    
                guard let unwrappedSelf = self else { return }
            
                let positionAnim: CABasicAnimation = CABasicAnimation(keyPath: "position")
                positionAnim.duration = 0.07
                positionAnim.repeatCount = 2
                positionAnim.autoreverses = true
                positionAnim.fromValue = NSValue(cgPoint: CGPoint(x: unwrappedSelf.errorLabel.center.x - 10, y: unwrappedSelf.errorLabel.center.y))
                positionAnim.toValue = NSValue(cgPoint: CGPoint(x: unwrappedSelf.errorLabel.center.x + 10, y: unwrappedSelf.errorLabel.center.y))
                unwrappedSelf.errorLabel.layer.add(positionAnim, forKey: nil)
            })
        }
    }
    
    private func isValidForm() -> Bool {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            
            setErrorLabel(isHidden: false, errorMessage: "Form is not valid")
            return false
        }
        
        // validate name text field only when registering
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1, name.isEmpty {
            
            nameTextField.isError(baseColor: nameTextField.tintColor.cgColor, numberOfShakes: 2, revert: true)
            setErrorLabel(isHidden: false, errorMessage: "Name field cannot be empty!")
            return false
        }
        
        if email.isEmpty {
            
            emailTextField.isError(baseColor: emailTextField.tintColor.cgColor, numberOfShakes: 2, revert: true)
            setErrorLabel(isHidden: false, errorMessage: "Email field cannot be empty!")
            return false
        }
        
        if !isValidEmail(email) {
            
            emailTextField.isError(baseColor: emailTextField.tintColor.cgColor, numberOfShakes: 2, revert: true)
            setErrorLabel(isHidden: false, errorMessage: "Email is in a wrong format!")
            return false
        }
        
        if password.isEmpty {
            
            passwordTextField.isError(baseColor: passwordTextField.tintColor.cgColor, numberOfShakes: 2, revert: true)
            setErrorLabel(isHidden: false, errorMessage: "Password field cannot be empty!")
            return false
        }
        
        // validate password length only when registering
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1, password.count < 6 {
            
            passwordTextField.isError(baseColor: passwordTextField.tintColor.cgColor, numberOfShakes: 2, revert: true)
            setErrorLabel(isHidden: false, errorMessage: "Password length must be more than 6 characters!")
            return false
        }
        
        setErrorLabel(isHidden: true)
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // On Segmented Control value changed
    @objc private func handleLoginRegisterChange() {
        
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        registerButton.setTitle(title, for: .normal)
        
        let isLoginSelected = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        // Set input text field height
        inputsContainerHeightConstraint?.isActive = false
        inputsContainerHeightConstraint = inputsContainerView.heightAnchor.constraint(equalToConstant: isLoginSelected ? textFieldsheight - (textFieldsheight / 3) : textFieldsheight)
        inputsContainerHeightConstraint?.isActive = true
        
        nameTextFieldHeightConstraint?.isActive = false
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: isLoginSelected ? 0 : 1 / 3)
        nameTextFieldHeightConstraint?.isActive = true
        nameTextField.isHidden = isLoginSelected
        
        emailTextFieldHeightContraint?.isActive = false
        emailTextFieldHeightContraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: isLoginSelected ? 1 / 2 : 1 / 3)
        emailTextFieldHeightContraint?.isActive = true
        
        passwordTextFieldHeightConstraint?.isActive = false
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: isLoginSelected ? 1 / 2 : 1 / 3)
        passwordTextFieldHeightConstraint?.isActive = true
        
        // Hide error label
        setErrorLabel(isHidden: true)
    }
    
    @objc private func handleLoginRegister() {
        
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    private func handleLogin() {
        
        if !isValidForm() { return }
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            
            setErrorLabel(isHidden: false, errorMessage: "Form is not valid")
            return
        }
        
        setLoading(true)
        
        // Auth login
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error != nil {
                
                print("Register error: \(String(describing: error?.localizedDescription))")
                self?.setErrorLabel(isHidden: false, errorMessage: error?.localizedDescription)
                self?.setLoading(false)
                return
            }
            
            // Successfully authenticate user
            
            self?.setLoading(false)
            
            guard let unwrappedSelf = self else { return }
            
            print("Login success! email: \(String(describing: authResult?.user.email))")
            
            unwrappedSelf.view.window?.rootViewController = UINavigationController(rootViewController: MainTabBarViewController())
            unwrappedSelf.view.window?.makeKeyAndVisible()
        }
    }
    
    private func handleRegister() {
        
        if !isValidForm() { return }
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            
            setErrorLabel(isHidden: false, errorMessage: "Form is not valid")
            return
        }
        
        setLoading(true)
        
        // Auth register
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            
            if error != nil {
                
                print("Register error: \(String(describing: error?.localizedDescription))")
                self?.setErrorLabel(isHidden: false, errorMessage: error?.localizedDescription)
                self?.setLoading(false)
                return
            }
            
            // Successfully authenticate user
            
            guard let uid = authResult?.user.uid else {
                
                print("Failed retrieving user uid")
                self?.setErrorLabel(isHidden: false, errorMessage: "Failed retrieving user uid")
                self?.setLoading(false)
                return
            }
            
            // Save into Firestore
            let ref = self?.db.collection("users")
            ref?.document(uid).setData([
                "name" : name,
                "email" : email,
            ], completion: { err in
                
                if err != nil {
                    print("Error saving to Firestore: \(String(describing: err))")
                    self?.setErrorLabel(isHidden: false, errorMessage: "Failed retrieving user uid")
                    self?.setLoading(false)
                    return
                }
                
                print("Saved user successfully into Firestore")
                self?.errorLabel.isHidden = false
                self?.errorLabel.text = "Register successful!"
                self?.setLoading(false)
            })
        }
    }
    
    private func setupLogoImage() {
        
        logoImageContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageContainer.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -45).isActive = true
        logoImageContainer.widthAnchor.constraint(equalToConstant: 180).isActive = true
        logoImageContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        logoImageContainer.addSubview(logoImageView)
        
        logoImageView.centerXAnchor.constraint(equalTo: logoImageContainer.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: logoImageContainer.centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageContainer.widthAnchor, constant: -45).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageContainer.heightAnchor, constant: -45).isActive = true
    }
    
    private func setupLoginRegisterSegmentedControl() {
        
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: inputsContainerView.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        loginRegisterSegmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
    }
    
    private func setupRegisterButton() {
        
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        registerButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 42).isActive = true
        
        registerButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
    }
    
    private func setupInputsContainerView() {
        
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        inputsContainerHeightConstraint = inputsContainerView.heightAnchor.constraint(equalToConstant: textFieldsheight)
        inputsContainerHeightConstraint?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        // Name text field
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        
        nameTextFieldHeightConstraint = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightConstraint?.isActive = true
        
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Email text field
        emailTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        
        emailTextFieldHeightContraint = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightContraint?.isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Password text field
        passwordTextField.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        
        passwordTextFieldHeightConstraint = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightConstraint?.isActive = true
        
        // Error label
        errorLabel.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        errorLabel.isHidden = true
    }
}
