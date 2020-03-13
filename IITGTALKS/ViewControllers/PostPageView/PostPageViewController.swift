//
//  PostPageView.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 19/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class PostPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        
        cell.userLabel.text = comments[comments.count-indexPath.row-1].username
        
        cell.dateLabel.text = "Posted on: \(Date(timeIntervalSince1970: comments[comments.count-indexPath.row-1].datePosted))"
        cell.commentTextView.text =  comments[comments.count-indexPath.row-1].text
        
        
        return cell
    }
    
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.text = "Posted on: \(Date())"
        label.textColor = .systemGray
        
        return label;
        
        
    }()
    
    let statLabel: UILabel = {
        
        let label = UILabel();
        label.font = UIFont.boldSystemFont(ofSize: 60)
        label.text = "0"
        label.textAlignment = .center
        return label;
        
    }()
    
    let postView = UIView()
    
    let commentsTable = UITableView()
    
    let commentsTextView: UITextView = {
        
        let textField = UITextView()
        //textField.placeholder = "Write your post here..."
        textField.backgroundColor = .systemFill
        textField.font = UIFont.systemFont(ofSize: 15)
        //textField.enablesReturnKeyAutomatically = true;
        return textField
        
    }()
    
    let postButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.label
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        return button
        
    }()
    
    let commentView: UIView = {
        
        let view = UIView()
        
        return view
        
    }()
    
    
    let upVoteButton: UIButton = {
        
        let origImage = UIImage(named: "upArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label
        
        button.setImage(tintedImage, for: .normal)
        
        button.addTarget(self, action: #selector(handleUpVote), for: .touchUpInside)
        
        return button
    }()
    
    let downVoteButton: UIButton = {
        
        let origImage = UIImage(named: "downArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label

        
        button.setImage(tintedImage, for: .normal)
        
        
        button.addTarget(self, action: #selector(handleDownVote), for: .touchUpInside)
        
        return button
    }()
    
    
    let postTextView: UITextView = {
        
        let tv = UITextView()
        tv.font = UIFont.boldSystemFont(ofSize: 20)
        tv.textColor = .label
        tv.isEditable = false
        
        return tv
        
        
    }()
    
    let usernameLabel: UILabel = {
    
        let label = UILabel();
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 400))
        label.text = "Username"
        
        return label;
    }()
    
    let commentsLabel: UILabel = {
    
        let label = UILabel();
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 200))
        label.text = "Comments:"
        
        return label;
    }()
    
    let userImageView: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "photoIcon.png")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .label
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.96)
        
        setupViews()
        
        setUpPostView()
        
        self.commentsTable.register(CommentsTableViewCell.self, forCellReuseIdentifier: "commentCell")
        commentsTable.dataSource = self
        commentsTable.delegate = self
        commentsTable.tableFooterView = UIView()
        
        hideKeyboardWhenTappedAround()
        
        
        
        fetchComments { (true) in
            
            self.commentsTable.reloadData()
            
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func setupViews(){
        
        view.addSubview(postView)
        view.addSubview(downArrowImageView)
        view.addSubview(swipeDownLabel)
        
        postView.translatesAutoresizingMaskIntoConstraints = false
        
        postView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        postView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        postView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        postView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        
        postView.layer.borderWidth = 2
        postView.layer.borderColor = UIColor.label.cgColor
        
        
        postView.addSubview(postTextView)
        postView.addSubview(userImageView)
        postView.addSubview(usernameLabel)
        postView.addSubview(upVoteButton)
        postView.addSubview(downVoteButton)
        postView.addSubview(statLabel)
        postView.addSubview(dateLabel)
        self.view.addSubview(commentsLabel)
        self.view.addSubview(commentsTable)
        self.view.addSubview(commentView)
        commentView.addSubview(commentsTextView)
        commentView.addSubview(postButton)
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentsTable.translatesAutoresizingMaskIntoConstraints = false
        commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        statLabel.translatesAutoresizingMaskIntoConstraints = false
        upVoteButton.translatesAutoresizingMaskIntoConstraints = false
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false;
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        postTextView.translatesAutoresizingMaskIntoConstraints = false
        commentsTextView.translatesAutoresizingMaskIntoConstraints = false
        
        
        commentView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor).isActive = true
        commentView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        commentView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        commentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        
        commentsTextView.leftAnchor.constraint(equalTo: self.commentView.leftAnchor, constant: 20).isActive = true
        commentsTextView.rightAnchor.constraint(equalTo: self.commentView.rightAnchor, constant:-90).isActive = true
        commentsTextView.bottomAnchor.constraint(equalTo: self.commentView.bottomAnchor).isActive = true
        commentsTextView.topAnchor.constraint(equalTo: self.commentView.topAnchor).isActive = true
        
        commentsTextView.clipsToBounds = true
        commentsTextView.layer.cornerRadius = 20
        commentsTextView.placeholder = "Add comment here..."
        commentsTextView.layer.borderColor = UIColor.label.cgColor
        commentsTextView.layer.borderWidth = 2
        commentsTextView.backgroundColor = .systemBackground
        
        postButton.clipsToBounds = true
        postButton.layer.cornerRadius = 20
        
        postButton.rightAnchor.constraint(equalTo: commentView.rightAnchor, constant: -5).isActive = true
        postButton.topAnchor.constraint(equalTo: commentView.topAnchor).isActive = true
        postButton.bottomAnchor.constraint(equalTo: commentView.bottomAnchor).isActive = true
        postButton.leftAnchor.constraint(equalTo: commentsTextView.rightAnchor, constant: 5).isActive = true
        
        commentsTable.leftAnchor.constraint(equalTo: postTextView.leftAnchor).isActive = true;
        commentsTable.rightAnchor.constraint(equalTo: postTextView.rightAnchor).isActive = true
        commentsTable.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor).isActive = true
        commentsTable.bottomAnchor.constraint(equalTo: commentView.topAnchor, constant: -10).isActive = true
        commentsTable.layer.borderWidth = 2;
        commentsTable.layer.borderColor = UIColor.label.cgColor
        commentsTable.separatorStyle = .none
        commentsTable.rowHeight = UITableView.automaticDimension
        commentsTable.estimatedRowHeight = 40.0
        
        commentsLabel.topAnchor.constraint(equalTo: postView.bottomAnchor).isActive = true
        commentsLabel.leftAnchor.constraint(equalTo: statLabel.centerXAnchor).isActive = true
        commentsLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        commentsLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: postTextView.bottomAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: postView.bottomAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: postView.rightAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: statLabel.rightAnchor, constant: 5).isActive = true
        
        statLabel.topAnchor.constraint(equalTo: downVoteButton.bottomAnchor, constant: 5).isActive = true
        statLabel.rightAnchor.constraint(equalTo: postTextView.leftAnchor, constant: -5).isActive = true
        statLabel.leftAnchor.constraint(equalTo: self.postView.leftAnchor, constant: 5).isActive = true
        statLabel.heightAnchor.constraint(equalToConstant: 65).isActive = true
        statLabel.adjustsFontSizeToFitWidth = true
        statLabel.baselineAdjustment = .alignCenters
        
        upVoteButton.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 20).isActive = true
        upVoteButton.rightAnchor.constraint(equalTo: postTextView.leftAnchor, constant: -5).isActive = true
        upVoteButton.leftAnchor.constraint(equalTo: self.postView.leftAnchor, constant: 5).isActive = true
        upVoteButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        
        downVoteButton.topAnchor.constraint(equalTo: upVoteButton.bottomAnchor, constant: 20).isActive = true
        downVoteButton.rightAnchor.constraint(equalTo: postTextView.leftAnchor, constant: -5).isActive = true
        downVoteButton.leftAnchor.constraint(equalTo: self.postView.leftAnchor, constant: 5).isActive = true
        downVoteButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        usernameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: userImageView.topAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: postView.rightAnchor, constant: -10).isActive = true
        usernameLabel.adjustsFontSizeToFitWidth = true
        
        
        
        userImageView.topAnchor.constraint(equalTo: postView.topAnchor, constant: 5).isActive = true
        userImageView.leftAnchor.constraint(equalTo: postView.leftAnchor, constant: 5).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 76).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 76).isActive = true
        
        userImageView.clipsToBounds = true
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 38
        userImageView.layer.borderWidth = 2
        userImageView.layer.borderColor = UIColor.label.cgColor
        
        postTextView.translatesAutoresizingMaskIntoConstraints = false
        postTextView.leftAnchor.constraint(equalTo: postView.leftAnchor, constant: 75).isActive = true
        postTextView.topAnchor.constraint(equalTo: postView.topAnchor, constant: 75).isActive = true
        postTextView.rightAnchor.constraint(equalTo: postView.rightAnchor, constant: -20).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: postView.bottomAnchor, constant: -20).isActive = true
        postTextView.layer.borderColor = UIColor.label.cgColor
        postTextView.layer.borderWidth = 2
        
        downArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        downArrowImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        downArrowImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        downArrowImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        downArrowImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        swipeDownLabel.translatesAutoresizingMaskIntoConstraints = false
        
        swipeDownLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        swipeDownLabel.leftAnchor.constraint(equalTo: downArrowImageView.rightAnchor, constant: 10).isActive = true
        swipeDownLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        swipeDownLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    func setUpPostView(){
        
        
        
        usernameLabel.text = postToShow.name
        
        dateLabel.text = "Posted on: \(Date(timeIntervalSince1970: postToShow.datePosted))"
        
        if postToShow.liked {
            
            upVoteButton.tintColor = .systemBlue
            
        } else if postToShow.disliked {
            
            downVoteButton.tintColor = .systemRed
            
            
        }
        
        statLabel.text = "\(postToShow.numberOfLiked)"
        
        
        guard let url = URL(string: postToShow.url) else { return }
        do {

            let data = try Data(contentsOf: url)
            self.postTextView.text = String(data: data, encoding: .utf8)

        } catch {

            print("couldn't load post")

        }
        
        
       
        
        guard let imageURL = URL(string: postToShow.userImage) else { return }
        
        
        do {
            
            let data = try Data(contentsOf: imageURL)
            self.userImageView.image = UIImage(data: data)
            
        } catch {
            
            print("couldn't load image")
            
        }
        
        
    }
    
    func fetchComments(completion: ((_ success: Bool) -> Void)? = nil){
        
        comments.removeAll()
        
        SVProgressHUD.show()
        
        let postRef = Firestore.firestore().collection("posts").document("\(postToShow.user)\(postToShow.postIndex)")
        
        postRef.collection("comments").getDocuments { (documents, err) in
            
            print("hit something")
            
            if let err = err{
                
                print("unable to fetch comments", err);
                SVProgressHUD.dismiss()
                completion?(true)
                return
                
            }
            
            
            
            guard let arr = documents?.documents else {
                
                SVProgressHUD.dismiss()
                completion?(true)
                return
                
                
            }
            
            if arr.count == 0 {
                
                SVProgressHUD.dismiss()
                completion?(true)
                
            }
            
            for document in arr {
                
                var values = [String: Any]()
                
                let docData = document.data()
                
                print("commentDocData:", docData)
                
                guard let textURl = docData["textURL"] as? String else {
                    SVProgressHUD.dismiss()

                    completion?(true)
                    return
                    
                }
                
                
                guard let url = URL(string: textURl) else {
                    SVProgressHUD.dismiss()

                    completion?(true)
                    return }
                
                do{
                    let postTextData = try Data(contentsOf: url)
                    values["text"] = String(data: postTextData, encoding: .utf8)
                    
                } catch {
                    
                    print("unable to fetch comment")
                    SVProgressHUD.dismiss()
                    completion?(true)
                    return
                }
                
                guard let commentUser = docData["user"] as? String else {
                    SVProgressHUD.dismiss()
    completion?(true)
    return }
                
                guard let datePosted = docData["datePosted"] as? Double else {
                    SVProgressHUD.dismiss()
    completion?(true)
    return }
                
                values["datePosted"] = datePosted
                
                values["user"] = commentUser
                Firestore.firestore().collection("users").document(commentUser).getDocument { (document2, err2) in
                    
                    if let err2 = err2 {
                        
                        print("unable to fetch username of commentor", err2)
                        SVProgressHUD.dismiss()
                        completion?(true)
                        return
                        
                    }
                    
                    guard let docData2 = document2?.data() else {
                        SVProgressHUD.dismiss()
                        completion?(true)
                        return
                        
                        
                    }
                    guard let username = docData2["username"] else {
                        SVProgressHUD.dismiss()
                        completion?(true)
                        return }
                    values["username"] = username
                    
                    let comment = Comment(dictionary: values)
                    
                    comments.append(comment)
                    
                    SVProgressHUD.dismiss()
                    completion?(true)
                    
                }
                
                
                
            }
            
            
            
        }
        
        
        
    }
    
    @objc func handleUpVote(){
        
        SVProgressHUD.show()
        
        let db = Firestore.firestore()
                
        let postRep = postToShow
        
        let uid = postToShow.user
        
        guard let uidSelf = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("users").document(uidSelf)
        db.collection("posts").document("\(uid)\(postRep.postIndex)").getDocument { (document, err) in
            
            
            if let err = err {
                
                print("couldn't fetch post", err)
                
                SVProgressHUD.dismiss()
                
                return
                
            }
            
            guard let docData = document?.data() else { return }
            
            var value = docData["numberOfLiked"] as! Int
            
            userRef.collection("dislikedPosts").document("\(postRep.user)\(postRep.postIndex)").getDocument { (document2, err2) in
                
                if let err2 = err2 {
                    
                    print("couldn't check if disliked", err2)
                    SVProgressHUD.dismiss()
                    
                    return
                    
                }
                
                if let document2 = document2, document2.exists {
                    
                    userRef.collection("dislikedPosts").document("\(postRep.user)\(postRep.postIndex)").delete { (errx) in
                        
                        if let errx = errx {
                            
                            print("error removing from delete", errx)
                            
                        }
                        
                        
                        
                    }
                    
                    posts[postRep.indexShown].disliked = false
                    postToShow.disliked = false
                    self.downVoteButton.tintColor = .label
                    value+=1
                    
                }
                
                userRef.collection("likedPosts").document("\(postRep.user)\(postRep.postIndex)").getDocument { (document3, err3) in
                    
                    if let err3 = err3 {
                        
                        print("unable to get liked data", err3)
                        SVProgressHUD.dismiss()
                        return
                        
                    }
                    
                    if let document3 = document3, document3.exists {
                        
                        userRef.collection("likedPosts").document("\(postRep.user)\(postRep.postIndex)").delete { (erry) in
                            
                            if let erry = erry {
                                
                                print("unable to get liked data", erry)
                                SVProgressHUD.dismiss()
                                return
                                
                            }
                            
                            
                            
                            
                        }
                        
                        value-=1
                        postToShow.liked = false
                        posts[postRep.indexShown].liked = false
                        self.upVoteButton.tintColor = .label
                        
                        
                    } else {
                        
                        
                        
                        userRef.collection("likedPosts").document("\(postRep.user)\(postRep.postIndex)").setData(docData) { (errm) in
                            
                            if let errm = errm {
                                
                                print("unable to like in server", errm)
                                SVProgressHUD.dismiss()
                                return
                                
                            }
                            
                            
                            
                            
                        }
                        
                        value+=1
                        posts[postRep.indexShown].liked = true
                        postToShow.liked = true
                        self.upVoteButton.tintColor = .systemBlue
                        
                    }
                    
                    
                    let values = ["numberOfLiked": value]
                    
                    
                    db.collection("posts").document("\(uid)\(postRep.postIndex)").setData(values, merge: true) { (errz) in
                        
                        if let errz = errz {
                            
                            
                            print("error liking", errz)
                            
                            SVProgressHUD.dismiss()
                            
                            return
                            
                        }
                        
                        db.collection("users").document(postRep.user).collection("posts").document(postRep.postIndex).setData(values, merge: true) { (errw) in
                            
                            if let errw = errw {
                                
                                print("unable to edit like", errw)
                                return
                            }
                            
                            
                            SVProgressHUD.dismiss()
                            posts[postRep.indexShown].numberOfLiked = value
                            self.statLabel.text = "\(value)"
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        
    }
    
    
    @objc func handleDownVote(){
        
        SVProgressHUD.show()
        
        let db = Firestore.firestore()
        
        let uid = postToShow.user
        
        guard let uidSelf = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("users").document(uidSelf)
        
        let postRep = postToShow
        
        db.collection("posts").document("\(uid)\(postRep.postIndex)").getDocument { (document, err) in
            
            if let err = err {
                
                
                print("couldn't fetch post", err)
                
                SVProgressHUD.dismiss()
                
                return
                
            }
            
            guard let docData = document?.data() else { return }
            
            var value = docData["numberOfLiked"] as! Int
            
            userRef.collection("likedPosts").document("\(postRep.user)\(postRep.postIndex)").getDocument { (document2, err2) in
            
                if let err2 = err2 {
                    
                    print("couldn't check if liked", err2)
                    
                    SVProgressHUD.dismiss()
                    
                    return
                    
                }
                
                
                
                if let document2 = document2, document2.exists {
                    
                    userRef.collection("likedPosts").document("\(postRep.user)\(postRep.postIndex)").delete { (errx) in
                        
                        if let errx = errx {
                            
                            print("error deleting from liked", errx)
                            
                            SVProgressHUD.dismiss()
                            
                            return
                            
                        }
                        
                        
                        
                        
                    }
                    
                    value -= 1
                    
                    posts[postRep.indexShown].liked = false
                    postToShow.liked = false
                    self.upVoteButton.tintColor = .label
                    
                    
                    
                    
                }
                
                userRef.collection("dislikedPosts").document("\(postRep.user)\(postRep.postIndex)").getDocument { (document3, err3) in
                    
                    if let err3 = err3 {
                        
                        print("unable to get dislike data", err3)
                        
                        SVProgressHUD.dismiss()
                        
                        return
                        
                    }
                    
                    if let document3 = document3, document3.exists {
                        
                        userRef.collection("dislikedPosts").document("\(postRep.user)\(postRep.postIndex)").delete { (erry) in
                        
                            if let erry = erry {
                                
                                
                                print("couldn't load dislike data", erry)
                                
                                SVProgressHUD.dismiss()
                                
                                return
                                
                            }
                            
                            
                            
                        }
                        
                        value+=1;
                        postToShow.disliked = false
                        posts[postRep.indexShown].disliked = false
                        self.downVoteButton.tintColor = .label
                        
                        
                        
                        
                    } else {
                        
                        
                        
                        userRef.collection("dislikedPosts").document("\(postRep.user)\(postRep.postIndex)").setData(docData) { (errm) in
                            
                            if let errm = errm {
                                
                                print("unable to like in server", errm)
                                SVProgressHUD.dismiss()
                                return
                                
                            }
                            
                            
                            
                        }
                        
                        value-=1;
                        posts[postRep.indexShown].disliked = true
                        postToShow.disliked = true
                        self.downVoteButton.tintColor = .systemRed
                        
                        
                    }
                    
                    
                    let values = ["numberOfLiked": value]
                    
                    db.collection("posts").document("\(uid)\(postRep.postIndex)").setData(values, merge: true) { (errz) in
                        
                        if let errz = errz {
                            
                            
                            print("error disliking", errz)
                            
                            SVProgressHUD.dismiss()
                            
                            return
                            
                        }
                        
                        db.collection("users").document(postRep.user).collection("posts").document(postRep.postIndex).setData(values, merge: true) { (errw) in
                            
                            if let errw = errw {
                                
                                print("unable to edit dislike", errw)
                                return
                            }
                            
                            
                            SVProgressHUD.dismiss()
                            self.statLabel.text = "\(value)"
                            posts[postRep.indexShown].numberOfLiked = value
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    @objc func handlePost(){
        
        postButton.isEnabled = false
        SVProgressHUD.show()
        
        guard let uploadText = commentsTextView.text else {
            
            print("no comment")
            
            let alertController = UIAlertController(title: "Comment Empty", message: "Empty comment are not permitted", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            postButton.isEnabled = true
            
            return
        }
        
        
        
        if uploadText == "" {
            
            print("no comment2")
            
            let alertController = UIAlertController(title: "Comment Empty", message: "Empty comments are not permitted.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            
            postButton.isEnabled = true
            
            return
            
            
            
        }
        
        
        let uploadData = Data(uploadText.utf8)
        
        let uid = postToShow.user
        
        guard let selfuid = Auth.auth().currentUser?.uid else { return }
       
        
        Firestore.firestore().collection("posts").document("\(uid)\(postToShow.postIndex)").getDocument { (document, err) in
            
            if let err = err {
                
                print("failed to comment", err)
                self.postButton.isEnabled = true
                SVProgressHUD.dismiss()
                return
                
            }
            
            guard let docData = document?.data() else { return }
            
            guard let value = docData["numberOfComments"] as? Int else { return }
            
           let postRef = Storage.storage().reference().child("comments").child(selfuid).child("\(uid)\(postToShow.postIndex)comment\(getThreeDigits(value+1))")
            
            postRef.putData(uploadData, metadata: nil) { (metadata, err2) in
                
                if let err2 = err2 {
                    
                    
                    print("failed to post comment to server", err2)
                    self.postButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    return
                    
                }
                
                postRef.downloadURL { (url, err3) in
                    
                    
                    if let err3 = err3 {
                        
                        print("couldn't get post url", err3)
                        self.postButton.isEnabled = true
                        SVProgressHUD.dismiss()
                        return
                        
                    }
                    
                    guard let url = url?.absoluteString else { return }
                    
                    var values = ["textURL": url, "user": selfuid, "datePosted": Date().timeIntervalSince1970] as [String: Any]
                   
                    Firestore.firestore().collection("posts").document("\(uid)\(postToShow.postIndex)").collection("comments").document("comment\(getThreeDigits(value+1))").setData(values, merge: true) { (err4) in
                        
                        values["username"] = currentUserUsername
                        values["text"] = uploadText
                        
                        let commentToBePosted = Comment(dictionary: values)
                        
                        comments.append(commentToBePosted)
                        
                        if let err4 = err4 {
                            
                            print("there was an error posting comment", err4)
                            self.postButton.isEnabled = true
                            SVProgressHUD.dismiss()
                            return
                            
                        }
                        
                        Firestore.firestore().collection("users").document(uid).collection("posts").document("\(postToShow.postIndex)").collection("comments").document("comment\(getThreeDigits(value+1))").setData(values, merge: true) { (err5) in
                            
                            if let err5 = err5 {
                                
                                print("unable to save comment to a section of database", err5)
                                self.postButton.isEnabled = true
                                SVProgressHUD.dismiss()
                                return
                                
                            }
                            
                            let values2 = ["numberOfComments": value+1] as [String: Any]
                            
                            
                            Firestore.firestore().collection("users").document(uid).collection("posts").document("\(postToShow.postIndex)").setData(values2, merge: true) { (err6) in
                                
                                if let err6 = err6 {
                                    
                                    print("unable to update number of comments in users collection", err6)
                                    self.postButton.isEnabled = true
                                    SVProgressHUD.dismiss()
                                    return
                                    
                                }
                                
                                Firestore.firestore().collection("posts").document("\(uid)\(postToShow.postIndex)").setData(values2, merge: true) { (err7) in
                                    if let err7 = err7 {
                                        print("unable to update number of comments in posts collection", err7)
                                        self.postButton.isEnabled = true
                                        SVProgressHUD.dismiss()
                                        return
                                    }
                                    
                                    self.postButton.isEnabled = true
                                    self.commentsTextView.text = ""
                                    
                                    self.commentsTable.reloadData()
                                    
                                    SVProgressHUD.dismiss()
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
            }
            
            
            
        }
        
        
        
    }
    
    
}
