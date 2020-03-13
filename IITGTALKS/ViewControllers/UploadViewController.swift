//
//  UploadViewController.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 10/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class UploadViewController: UIViewController, UITextViewDelegate {

    
    
    let postButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.label
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        return button
        
    }()
    
    
    
    let postTextField: UITextView = {
        
        let textField = UITextView()
//        textField.placeholder = "Write your post here..."
        textField.backgroundColor = .systemFill
        textField.font = UIFont.systemFont(ofSize: 15)
        //textField.enablesReturnKeyAutomatically = true;
        return textField
        
    }()
    
    let downArrowImageView: UIImageView = {
        
        let iv = UIImageView()
        iv.image = UIImage(named: "down")
        iv.contentMode = .scaleAspectFit
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .label
        
        return iv
        
    }()
    
    let swipeDownLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Swipe Down to dismiss."
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
        
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    
    @objc func handlePost(){
        
        print("handling post")
        
        postButton.isEnabled = false
        
        guard let uploadText = postTextField.text else {
            
            print("no post")
            
            let alertController = UIAlertController(title: "Post Empty", message: "Empty posts are not permitted", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            postButton.isEnabled = true
            
            return
        }
        
        let uploadData = Data(uploadText.utf8)
        
        if uploadText == "" {
            
            print("no post2")
            
            let alertController = UIAlertController(title: "Post Empty", message: "Empty posts are not permitted.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            postButton.isEnabled = true
            
            return
            
            
            
        }
        
        
        let filename = NSUUID().uuidString
       
        guard let uid = Auth.auth().currentUser?.uid else {
            self.handleFailedPost()
            return
            
        }
        
        let postRef = Storage.storage().reference().child("posts").child(uid).child(filename)
        
        postRef.putData(uploadData, metadata: nil) { (metadata, err) in
            
            if let err = err {
                
                print("Failed to post", err)
                
                self.postButton.isEnabled = true
                
                self.handleFailedPost()
                
                return
                
            }
            
            postRef.downloadURL { (url, err2) in
                
                if let err2 = err2 {
                    
                    print("couldn't download url", err2)
                    
                    self.postButton.isEnabled = true
                    self.handleFailedPost()
                    
                    return
                    
                }
                
                guard let URL = url?.absoluteString else { return }
                
                
                self.savePostToDatabase(url: URL)

                
                
            }
            
        }
        
    }
    
    
    
    
    
    fileprivate func savePostToDatabase(url: String){
        
        let db = Firestore.firestore()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        
        
        let userRef = db.collection("users").document(uid)
        
        var value: Int = 0
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                print("Document data:, \(dataDescription!)")
                
                var values = ["URL": url, "numberOfLiked": 0, "datePosted": Date().timeIntervalSince1970, "user": uid, "numberOfComments": 0] as [String : Any]
                
                guard let value2 = dataDescription?["numberOfPosts"] as? Int else {
                    print("unSuccessFuLl")
                    
                    self.postButton.isEnabled = true
                    
                    self.handleFailedPost()
                    
                    return
                    
                }
                
                if let temp1 = dataDescription?["profilePictureURL"] as? String {
                    
                    values["profilePictureURL"] = temp1
                    
                }
                if let temp2 = dataDescription?["username"] as? String {
                    
                    values["username"] = temp2
                    
                }
                
                
                
                print("value2:", value2)
                
                value=value2+1
                
                
                 
                print(value)
                
                let tempVal = getThreeDigits(value)
                
                db.collection("posts").document("\(uid)post\(tempVal)").setData(values, merge: true)
                
                
                
                 userRef.setData(["numberOfPosts": value], merge: true)
                 userRef.collection("posts").document("post\(tempVal)").setData(values, merge: true)
                
                NUMBER_OF_POSTS+=1;
                
                
                userRef.collection("posts").order(by: document.documentID, descending: true)
                db.collection("posts").order(by: document.documentID, descending: true)
                
                self.dismiss(animated: true, completion: nil)
                
            } else {
                
                self.postButton.isEnabled = true
                self.handleFailedPost()
                
                print("Document does not exist")
            }
            
        }
        
        
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = .systemBackground
        
        postTextField.delegate = self;
        
        view.addSubview(postButton)
        view.addSubview(postTextField)
        view.addSubview(downArrowImageView)
        view.addSubview(swipeDownLabel)
        
        let margins = view.layoutMarginsGuide
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint = postButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        bottomConstraint?.isActive = true
        postButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        postButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardHideNotification), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
        postTextField.translatesAutoresizingMaskIntoConstraints = false
        
        postTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true;
        postTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true;
        postTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        postTextField.bottomAnchor.constraint(equalTo: postButton.topAnchor, constant: 0).isActive = true
        
        
        
        downArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        downArrowImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        downArrowImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        downArrowImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        downArrowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        swipeDownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        swipeDownLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        swipeDownLabel.leftAnchor.constraint(equalTo: downArrowImageView.rightAnchor, constant: 10).isActive = true
        swipeDownLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        swipeDownLabel.bottomAnchor.constraint(equalTo: postTextField.topAnchor, constant: 0).isActive = true
        
        
        

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        postTextField.becomeFirstResponder();
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            bottomConstraint?.constant = -keyboardFrame.height + view.safeAreaInsets.bottom
            
        }
        
    }
    
    @objc func handleKeyBoardHideNotification(){
        
        bottomConstraint?.constant = 0
        
    }
    
    
    func handleFailedPost(){
        
        let alertController = UIAlertController(title: "Failed to post.", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    


}

extension UITextView :UITextViewDelegate
{

    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }

    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height

            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()

        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()

        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100

        placeholderLabel.isHidden = self.text.count > 0

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}

