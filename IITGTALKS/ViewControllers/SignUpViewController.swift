//
//  ViewController.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 02/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let logInButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14) , NSAttributedString.Key.foregroundColor: UIColor.label]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        return button
        
    }()
    
    let photoButton: UIButton = {
        
        let origImage = UIImage(named: "photoIcon.png")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label

        
        button.setImage(tintedImage, for: .normal)
        
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
        
    }()
    
    let emailTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = .systemFill
        textField.borderStyle = .roundedRect
        
        return textField
        
    }()
        
    let usernameTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = .systemFill
        textField.borderStyle = .roundedRect
        
        return textField
        
    }()

    let passwordTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .systemFill
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        
        textField.textColor = .label
        
        return textField
        
    }()
    
    
    let signUpButton: UIButton = {
        
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 5
        button.setTitleColor(.systemBackground, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
     
        return button
        
        
    }()
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loadinng the view.

        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = .systemBackground
            
        
        view.addSubview(photoButton)
        view.addSubview(logInButton)
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        
        photoButton.heightAnchor.constraint(equalToConstant: 140).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 140).isActive = true
        photoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true

    
        
        navigationController?.isNavigationBarHidden = true
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        logInButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        logInButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        logInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupStack()
        
    }

    func setupStack(){
        
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, emailTextField, passwordTextField, signUpButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
        stackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
        stackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30),
        stackView.heightAnchor.constraint(equalToConstant: 200),
        stackView.topAnchor.constraint(equalTo: self.photoButton.bottomAnchor, constant: 20)
        ])
        
        
    }

    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }

        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    func isValidUsername(Input:String) -> Bool {
        
        let RegEx = "\\w{7,18}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: Input)
        
    }
    
    @objc func handlePhoto(){
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            
            self.photoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoButton.layer.cornerRadius = self.photoButton.frame.width/2
            photoButton.layer.masksToBounds = true
            photoButton.layer.borderColor = UIColor.label.cgColor
            photoButton.layer.borderWidth = 3

            
        } else if let origImage = info[.originalImage] as? UIImage {
            
            self.photoButton.setImage(origImage.withRenderingMode(.alwaysOriginal), for: .normal)
            
            photoButton.layer.cornerRadius = self.photoButton.frame.width/2
            photoButton.layer.masksToBounds = true
            photoButton.layer.borderColor = UIColor.label.cgColor
            photoButton.layer.borderWidth = 3

            
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleSignUp(){
        
        if((emailTextField.text ?? "").isEmpty || (passwordTextField.text ?? "").isEmpty || (passwordTextField.text ?? "").isEmpty){
            
            let alert = UIAlertController(title: "Not yet filled", message: "Please fill up the form first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
            
        } else if (isValidEmail(email: emailTextField.text) == false){
            
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter a valid Email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        } else if(isValidPassword(testStr: passwordTextField.text) == false){
            
            let alert = UIAlertController(title: "Invalid Password", message: "Please enter at least one uppercase, one lowercase, one digit and eight characters in total", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

            
        } else if(isValidUsername(Input: usernameTextField.text!) == false){
            
            let alert = UIAlertController(title: "Invalid Username", message: "Only letters, underscores and numbers allowed. Should be of minimum length 7 and maximum length 18", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        
        } else{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
                
                if let err = err {
                    
                    print("Signup error", err)
                    self.handleSignUpError(err)
                    return
                    
                }
                
                print("Successfully Created User", result?.user.uid ?? "")
                
                guard let uid = result?.user.uid else {
                    return
                }
                
                let st = Storage.storage()
                
                
                guard let image = self.photoButton.imageView?.image else {
                    return
                }
                
                guard let uploadData = image.jpegData(compressionQuality: 0.3) else {
                    return
                }
                
                let values = ["username": self.usernameTextField.text!, "numberOfPosts": 0] as [String : Any]
                               
                print(values)
                   
                let db = Firestore.firestore()
                db.collection("users").document(uid).setData(values)
                

                var profilePictureUrl: String? = "https://firebasestorage.googleapis.com/v0/b/iitgtalks.appspot.com/o/defaultProfilePicture%2Ficonmonstr-picture-15-240.png?alt=media&token=18c67aa5-07cc-44c6-a6da-d4f3fedc5356"
                
                let profilePictureRef = st.reference().child("profile_images").child(uid)
                
                profilePictureRef.putData(uploadData, metadata: nil) { (meta, err) in
                    
                    if let err = err {
                        
                        print("could not upload image", err)
                        
                    }
                    
                    profilePictureRef.downloadURL { (url, err2) in
                        
                        if let err2 = err2{
                            
                            print("ERROR: ", err2)
                            return
                            
                        }
                        
                        profilePictureUrl = url?.absoluteString
                        print("success!!!", profilePictureUrl!)
                        db.collection("users").document(uid).setData(["profilePictureURL": profilePictureUrl!], merge: true)
                        
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
            
            
        }
        
        
    }
    
    func handleSignUpError(_ error: Error){
        if let errorCode = AuthErrorCode(rawValue: error._code){
            var errorTitle: String = ""
            var errorMessage: String = ""
            
            let defaultAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            
            var actions = [UIAlertAction]()
            switch(errorCode){
                case .invalidEmail, .invalidSender, .invalidRecipientEmail:
                    errorTitle = "Invalid Email"
                    errorMessage = "Please enter a valid Email."
                    actions.append(defaultAction)
                
                case .emailAlreadyInUse:
                    errorTitle = "User Already Registered"
                    errorMessage = "A user is already registered with this Email. Click 'Login' to use this account"
                    
                    let action1 = UIAlertAction(title: "Try Again", style: .cancel, handler: { (_) in
                        self.emailTextField.text = "";
                        self.passwordTextField.text = "";
                    })
                    
                    let action2 = UIAlertAction(title: "Log In", style: .default, handler: { (_) in
                        //let email = self.emailTextField.text
                        
                        self.usernameTextField.text = ""
                        self.emailTextField.text = "";
                        self.passwordTextField.text = "";
                        
                        self.handleShowLogIn()
                    })
                    
                    actions.append(action1)
                    actions.append(action2)
                
                case .networkError:
                    errorTitle = "Network Error"
                    errorMessage = "Please make sure you are connected to the Internet."
                    actions.append(defaultAction)
                
                default:
                    errorTitle =  "Unknown error occurred"
                    errorMessage =  "Sorry for the inconvenience."
                    actions.append(defaultAction)
            }
            
            let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            
            actions.forEach({ (action) in
                alertController.addAction(action)
            })
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleShowLogIn(){
        
        navigationController?.popViewController(animated: true)
        
    }
    
}



extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
