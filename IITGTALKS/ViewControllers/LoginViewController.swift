//
//  LoginViewController.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 02/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class LoginViewController: UIViewController {

    let signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor: UIColor.label]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
        
    }()
    
    let emailTextField: UITextField = {
        
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemFill
        tf.textColor = .label
        tf.placeholder = "Email"
        
        return tf
        
    }()
    
    let passwordTextField: UITextField = {
        
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemFill
        tf.textColor = .label
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        
        return tf
        
    }()
    
    let loginButton: UIButton = {
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 5
        button.setTitle("Log In", for: .normal)

        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        
        return button
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        self.hideKeyboardWhenTappedAround()
        
        setupStack()
        
        
        self.view.addSubview(signUpButton)
        
        navigationController?.isNavigationBarHidden = true
        
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        signUpButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        signUpButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        // Do any additional setup after loading the view.
    }
    

    func setupStack(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            stackView.heightAnchor.constraint(equalToConstant: 150)
        
        ])
        
        
    }
    
    @objc func handleLogIn(){
        
        let temp = SignUpViewController()
        
        if ((emailTextField.text ?? "").isEmpty || (passwordTextField.text ?? "").isEmpty){
            
            let alert = UIAlertController(title: "Not yet filled", message: "Please fill both fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
        } else if (temp.isValidEmail(email: emailTextField.text ?? "") == false){
         
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid Email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else if (temp.isValidPassword(testStr: passwordTextField.text ?? "") == false){
            
            let alert = UIAlertController(title: "Invalid Password", message: "Please enter at least one uppercase, one lowercase, one digit and eight characters in total", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            guard let email = emailTextField.text else { return }
            guard let password = passwordTextField.text else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
                
                if let err = err {
                    
                    print("failed to sign in", err)
                    return
                    
                }
                
                print("successfully logged in", result?.user.uid ?? "")
                
                guard let mainTabBarController =  UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else { return }
                
                mainTabBarController.setupViewControllers()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @objc func handleShowSignUp(){
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
