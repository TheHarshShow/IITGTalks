//
//  ProfileViewController.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 09/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if(posts.count==0){
        
            
            self.view.addSubview(postAlert)
            
            
        } else {
            
            self.postAlert.removeFromSuperview()
            
        }
        
        return posts.count
    }

    
    var dictLikes = Dictionary<IndexPath, Int>()
    var dictName = Dictionary<IndexPath, String>()
    var DictDate = Dictionary<IndexPath, String>()
    var dictImage = Dictionary<IndexPath, UIImage>()
    var dictPost = Dictionary<IndexPath, String>()
    var check2 = Set<IndexPath>()
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        
        
        if !self.refreshControl!.isRefreshing {
        

            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            
            cell.postRepresented = posts[posts.count - indexPath.row - 1]
            
            
            if cell.postRepresented?.disliked ?? false {
                
                cell.downVoteButton.tintColor = .systemRed
                
            } else {
                
                
                cell.downVoteButton.tintColor = .label
                
            }
            
            if check2.contains(indexPath) {
                
                cell.statLabel.text = "\(cell.postRepresented!.numberOfLiked)"
                cell.userImage.image = dictImage[indexPath]
                cell.userLabel.text = cell.postRepresented?.name
                cell.dateLabel.text = DictDate[indexPath]
                cell.postTextView.text = dictPost[indexPath]
                
                if cell.postRepresented?.liked ?? false{
                    
                    cell.upVoteButton.tintColor = .systemBlue
                    
                } else {
                    
                    cell.upVoteButton.tintColor = .label
                    
                }
                
                
                
            } else {
                
                
                

                
                check2.insert(indexPath)
                
                if cell.postRepresented?.liked ?? false {
                    
                    cell.upVoteButton.tintColor = .systemBlue
                    
                    
                } else {
                    
                    cell.upVoteButton.tintColor = .label
                    
                }
                
                dictLikes[indexPath] = cell.postRepresented?.numberOfLiked
                
                cell.statLabel.text = "\(dictLikes[indexPath]!)"
                
                cell.userLabel.text = cell.postRepresented?.name
                           
               guard let txt = cell.postRepresented?.url else { return cell }
               
               
               
               guard let url = URL(string: txt) else { SVProgressHUD.dismiss(); return cell }
               
               guard let txt2 = cell.postRepresented?.userImage else { SVProgressHUD.dismiss(); return cell }
               
               
               guard let url2 = URL(string: txt2) else { return cell }
               
               
               if let date = cell.postRepresented?.datePosted{
                   
                DictDate[indexPath] = "Posted on: \(Date(timeIntervalSince1970: date))"
                cell.dateLabel.text = DictDate[indexPath]
                   
               }
                
                do {
                    
                    
                    let data = try Data(contentsOf: url)
                    
                    
                    dictPost[indexPath] = String(data: data, encoding: .utf8)
                    cell.postTextView.text = dictPost[indexPath]

                } catch {
                    
                    print("couldn't load post")
                    
                    
                }
                
                
                do {
                    print("url2: ", url2)
                    
                    let data2 = try Data(contentsOf: url2)
                    dictImage[indexPath] = UIImage(data: data2)
                    cell.userImage.image = dictImage[indexPath]
                } catch {
                    
                    print("couldn't load image")
                    
                }
                
            }
            
            
            
            
            
            
            
        }
        
        
        
        SVProgressHUD.dismiss()
        
        return cell
        
    }
    
    let editPictureButton: UIButton = {
        
        let button = UIButton()
        
        
        button.setTitle("Edit Picture", for: .normal);
        button.addTarget(self, action: #selector(handleEditPicture), for: .touchUpInside)
        
        return button;
        
    }()
    
    let followerLabel: UILabel = {
        
        let label = UILabel();
        
        label.text = "Number of followers: "
        label.font = UIFont.italicSystemFont(ofSize: 13);
        label.textColor = .systemGray
        label.textAlignment = .left
        
        return label;
        
        
    }()
    let postCountLabel: UILabel = {
        
        let label = UILabel();
        
        label.text = "Number of followers: "
        label.font = UIFont.italicSystemFont(ofSize: 13);
        label.textColor = .systemGray
        label.textAlignment = .left
        
        return label;
        
        
    }()
    
    let postAlert: UILabel = {
        
        let label = UILabel()
        
        label.text = "No posts yet...";
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.textColor = .systemGray
        label.textAlignment = .center
        
        
        return label
        
        
    }()
    
    let separationConstant: CGFloat = 100.0

    
    let profilePicture: UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "photoIcon.png")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .label
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFill 
        imageView.clipsToBounds = true
                
        return imageView
        
    }()
    
    let usernameLabel: UILabel = {
        
        let label = UILabel();
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 400))
        label.text = "Username"
        
        return label;
        
    }()
    
    let postTable = UITableView()
    
    //var refreshControl = UIRefreshControl()
    
    let userStatsView = UIView()
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        editPictureButton.setTitle("Edit Picture", for: .normal);
        postTable.delegate = self;
        postTable.dataSource = self
        
         refreshControl = UIRefreshControl.init()
           refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl!.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        postTable.addSubview(refreshControl!)
        
        postTable.estimatedRowHeight = 60;
        postTable.rowHeight = UITableView.automaticDimension
        //postTable.rowHeight = 100;
        
        postTable.tableFooterView = UIView()

        
        view.backgroundColor = .systemBackground
        
        postTable.register(PostTableViewCell.self, forCellReuseIdentifier: "postCell")
        
        view.addSubview(postTable)
        postTable.translatesAutoresizingMaskIntoConstraints = false
        
        postTable.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true;
        postTable.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true;
        postTable.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -1*separationConstant).isActive = true;
        postTable.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        view.addSubview(userStatsView)
        userStatsView.translatesAutoresizingMaskIntoConstraints = false
        userStatsView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        userStatsView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        userStatsView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 2*navigationController!.navigationBar.frame.size.height).isActive = true
        userStatsView.bottomAnchor.constraint(equalTo: postTable.topAnchor).isActive = true
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Profile"
        
        userStatsView.layer.cornerRadius = 10
        userStatsView.layer.borderColor = UIColor.black.cgColor
        userStatsView.layer.borderWidth = 3
        
        view.addSubview(postAlert)

        postAlert.translatesAutoresizingMaskIntoConstraints = false;
        postAlert.topAnchor.constraint(equalTo: self.userStatsView.bottomAnchor, constant: 5).isActive = true
        postAlert.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        postAlert.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        postAlert.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        setupUserStatsView()
        
        SVProgressHUD.show()
        
        fetchUser { (true) in
            self.fetchPosts { (true) in
                
                
                self.postTable.reloadData()
                
                SVProgressHUD.dismiss()
                
                
            }
            
            self.setupLogOutButton()
            
        }
        
        
        
        



        
    }
    
    
    
    
    func fetchPosts(completion: ((_ success: Bool) -> Void)? = nil){
        
        posts.removeAll()
        
                
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("users").document(uid).collection("dislikedPosts").getDocuments { (documentx, errx) in
            
            if let errx = errx {
                
                print("error has occured checking dislikes", errx)
                return
                
                
            }
            
            var arrx = Set<String>()
            
            for document in documentx?.documents ?? [] {
                
                arrx.insert(document.documentID)
                print("testingDislikeFetch", document.documentID)
                
            }
            
            Firestore.firestore().collection("users").document(uid).collection("likedPosts").getDocuments { (documents, err) in
                
                
                
                if let err = err {
                    
                    print("massive error", err)
                    
                    completion?(true)
                    return
                    
                }
                
                var arr2 = Set<String>()
                
                for document in documents?.documents ?? [] {
                    
                    arr2.insert(document.documentID)
                    print("testing", document.documentID)
                    
                }
                
                let ref = Firestore.firestore().collection("users").document(uid).collection("posts")
                
                ref.getDocuments { (snapshot, err2) in
                    
                    if let err2 = err2 {
                        
                        print("failed to fetch posts", err2)
                        
                        completion?(true)
                        
                        return
                        
                    }
                    
                    guard let arr = snapshot?.documents else { return }
                    
                    for document in arr{
                        
                        
                        var dataDescription = document.data()
                        
                        dataDescription["postIndex"] = document.documentID
                        
                        print("documentData: \(document.documentID)")
                        
                        print("fetchdata:", dataDescription)
                        
                        dataDescription["indexShown"] = posts.count
                        
                        if arr2.contains("\(uid)\(document.documentID)"){
                            
                            dataDescription["liked"] = true
                            
                        } else {
                            
                            dataDescription["liked"] = false
                            
                        }
                        
                        if arrx.contains("\(uid)\(document.documentID)"){
                            
                            dataDescription["disliked"] = true
                            
                        } else {
                            
                            dataDescription["disliked"] = false
                            
                            
                        }
                        
                        
                        
                        let post = Post(dictionary: dataDescription)
                        
                        posts.append(post)
                        
                        
                    }
                    
                    

                    completion?(true)
                    
                }

            }
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    @objc func handleRefresh(){
        
        
        
        posts.removeAll()
        
        followerLabel.text = "Number Of Followers: \(NUMBER_OF_FOLLOWERS)"
        postCountLabel.text = "Number Of Posts: \(NUMBER_OF_POSTS)"
        
        DispatchQueue.main.async {
            

            self.check2.removeAll()
            
            
            
            self.dictImage.removeAll()
            self.dictPost.removeAll()
            self.DictDate.removeAll()
            self.dictName.removeAll()
            self.dictLikes.removeAll()
            
                
                
            self.fetchPosts { (true) in
                
                
                self.refreshControl!.endRefreshing()
                
                self.postTable.reloadData()
                
                if(posts.count>0){
                    
                    self.postAlert.removeFromSuperview()
                    return
                    
                }
                
                
                
                
            }
            
                
                
                
            
            
        }

        

        
        
    }
    
    fileprivate func setupLogOutButton(){
        
        let image = UIImage(named: "gear")?.withRenderingMode(.alwaysTemplate).withTintColor(UIColor.label)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
    }
    
    fileprivate func setupUserStatsView(){
        
        userStatsView.backgroundColor = .white
        userStatsView.addSubview(profilePicture)
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        profilePicture.leftAnchor.constraint(equalTo: userStatsView.leftAnchor, constant: 30).isActive = true
        profilePicture.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profilePicture.topAnchor.constraint(equalTo: userStatsView.topAnchor, constant: 30).isActive = true
        
        profilePicture.clipsToBounds = true
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = 50
        profilePicture.layer.borderWidth = 2
        profilePicture.layer.borderColor = UIColor.black.cgColor

        userStatsView.addSubview(usernameLabel)
        
        usernameLabel.numberOfLines = 1
        usernameLabel.textColor = .black
        usernameLabel.adjustsFontSizeToFitWidth = true

        usernameLabel.minimumScaleFactor = 0.1
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profilePicture.rightAnchor).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: userStatsView.rightAnchor, constant: -10).isActive = true
        
        
        userStatsView.addSubview(followerLabel);
        followerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        followerLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true;
        followerLabel.leftAnchor.constraint(equalTo: profilePicture.rightAnchor, constant: 10).isActive = true;
        followerLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true;
        followerLabel.rightAnchor.constraint(equalTo: self.userStatsView.rightAnchor).isActive = true;
        followerLabel.text = "Number Of Followers: \(NUMBER_OF_FOLLOWERS)"
        
        userStatsView.addSubview(postCountLabel);
        postCountLabel.translatesAutoresizingMaskIntoConstraints = false;
        postCountLabel.topAnchor.constraint(equalTo: followerLabel.bottomAnchor, constant: 5).isActive = true
        postCountLabel.leftAnchor.constraint(equalTo: followerLabel.leftAnchor).isActive = true;
        postCountLabel.rightAnchor.constraint(equalTo: self.userStatsView.rightAnchor).isActive=true;
        postCountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true;
        postCountLabel.text = "Number of Posts: \(NUMBER_OF_POSTS)"
        
        userStatsView.addSubview(editPictureButton)
        editPictureButton.translatesAutoresizingMaskIntoConstraints = false
        
        editPictureButton.topAnchor.constraint(equalTo: self.postCountLabel.bottomAnchor, constant: 10).isActive = true;
        editPictureButton.leftAnchor.constraint(equalTo: self.postCountLabel.leftAnchor, constant: 0).isActive = true;
        editPictureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        editPictureButton.widthAnchor.constraint(equalToConstant: 100).isActive = true;
        editPictureButton.layer.cornerRadius = 3;
        editPictureButton.layer.borderColor = UIColor.label.cgColor
        editPictureButton.layer.borderWidth = 2;
        editPictureButton.setTitleColor(UIColor.label, for: .normal)
        editPictureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        editPictureButton.setTitleColor(.systemGray, for: .highlighted)
        
        
    }
    
    fileprivate func fetchUser(completion: ((_ success: Bool) -> Void)? = nil) {
        
        let db = Firestore.firestore()
        
        guard Auth.auth().currentUser != nil else { return }
        
        let docRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                print("Document data:, \(dataDescription!)")
                self.usernameLabel.text = dataDescription?["username"] as? String
                let url = URL(string: dataDescription?["profilePictureURL"] as! String)
                
                do{
                    let data = try Data(contentsOf: url!)
                    self.profilePicture.image = UIImage(data: data)
                    
                } catch {
                    
                    print("profile picture not found in url")
                    
                }
            } else {
                print("Document does not exist")
            }
            self.followerLabel.text = "Number Of Followers: \(NUMBER_OF_FOLLOWERS)"
            self.postCountLabel.text = "Number of Posts: \(NUMBER_OF_POSTS)"
            completion?(true)
        }
        
    }
    
    
    
    @objc fileprivate func handleLogOut(){
        
        print("logging out")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            print("perform log out")
            do{
                try Auth.auth().signOut()
                
            } catch let signOutError{
                
                 print("failed to sign out", signOutError)
            }
            
            let loginViewController = LoginViewController()
            let navController = UINavigationController(rootViewController: loginViewController)
            navController.isModalInPresentation = true
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @objc func handleEditPicture(){
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage{
            
            self.profilePicture.image = editedImage.withRenderingMode(.alwaysOriginal)
            
            profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
            profilePicture.layer.masksToBounds = true
            profilePicture.layer.borderColor = UIColor.label.cgColor
            profilePicture.layer.borderWidth = 3
            
            let st = Storage.storage()
            
            guard let image = self.profilePicture.image else {
                return
            }
            
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {
                return
            }
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
             let profilePictureRef = st.reference().child("profile_images").child(uid)
            
            profilePictureRef.putData(uploadData, metadata: nil) { (meta, err) in
                
                if let err = err {
                    
                    print("couldn't change image", err);
                    return;
                    
                }
                
                profilePictureRef.downloadURL { (url, err2) in
                    
                    if let err2 = err2 {
                        
                        print("couldn't download url", err2);
                        return;
                        
                    }
                    
                    let profilePictureUrl = url?.absoluteString
                    print("successfully download url of image", profilePictureUrl!);
                    Firestore.firestore().collection("users").document(uid).setData(["profilePictureURL": profilePictureUrl!], merge: true);
                    
                    
//                    Firestore.firestore().collection("users").document(uid).collection("posts").getDocuments { (documents, err) in
//                        
//                        if let err = err{
//                            
//                            print("there was an error", err);
//                            return
//                            
//                        }
//                        
//                        guard let arr2 = documents else { return }
//                        
//                        for document in arr2.documents {
//                            
//                            document.setValue(profilePictureUrl!, forKey: "profilePictureURL")
//                            
//                            
//                        }
//                        
//                    }
                    
                    for i in stride(from: 0, to: posts.count, by: 1){
                        
                        posts[i].userImage = profilePictureUrl!
                        
                    }
                    
                }
                
                
            }
            
        } else if let origImage = info[.originalImage] as? UIImage {
            
            self.profilePicture.image = origImage.withRenderingMode(.alwaysOriginal)
            
            profilePicture.layer.cornerRadius = self.profilePicture.frame.width/2
            profilePicture.layer.masksToBounds = true
            profilePicture.layer.borderColor = UIColor.label.cgColor
            profilePicture.layer.borderWidth = 3

            
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}
