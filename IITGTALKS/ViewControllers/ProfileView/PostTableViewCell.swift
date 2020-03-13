//
//  PostTableViewCell.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 13/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var postRepresented: Post?
    
    
    let statLabel: UILabel = {
        
        let label = UILabel();
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "0"
        label.textAlignment = .center
        return label;
        
    }()
    
    
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.italicSystemFont(ofSize: 13)
        label.text = "Posted on: \(Date())"
        label.textColor = .systemGray
        
        return label;
        
        
    }()
    
    let userImage: UIImageView = {
       
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "photoIcon.png")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .label
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        
        return imageView
        
    }()
    
    let upVoteButton: UIButton = {
        
        let origImage = UIImage(named: "upArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label
        
        button.setImage(tintedImage, for: .normal)
        
        return button
    }()
    
    let downVoteButton: UIButton = {
        
        let origImage = UIImage(named: "downArrow")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label

        
        button.setImage(tintedImage, for: .normal)
        
        
        return button
    }()
    
    let openButton: UIButton = {
        
        let origImage = UIImage(named: "open")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        let button = UIButton(type: UIButton.ButtonType.system) as UIButton
        button.tintColor = .label

        
        button.setImage(tintedImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
        
        
        
    }()
    
    let postTextView: UITextView = {
        
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 16)
        
        return tv
        
    }()
    
    let userLabel: UILabel = {

        let label = UILabel()

        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .label
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        self.contentView.isUserInteractionEnabled = true;
        
        upVoteButton.isUserInteractionEnabled = true;
        downVoteButton.isUserInteractionEnabled = true;
        openButton.isUserInteractionEnabled = true;
        
        upVoteButton.addTarget(self, action: #selector(handleUpVote), for: .touchUpInside)
        downVoteButton.addTarget(self, action: #selector(handleDownVote), for: .touchUpInside)
        openButton.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        
        self.selectionStyle = .none
        
        adjustUITextViewHeight(arg: postTextView)
        
        
        contentView.addSubview(userLabel)
        contentView.addSubview(userImage)
        contentView.addSubview(postTextView)
        contentView.addSubview(upVoteButton)
        contentView.addSubview(downVoteButton)
        contentView.addSubview(statLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(openButton)
        
        openButton.translatesAutoresizingMaskIntoConstraints = false;
        dateLabel.translatesAutoresizingMaskIntoConstraints = false;
        userLabel.translatesAutoresizingMaskIntoConstraints = false;
        userImage.translatesAutoresizingMaskIntoConstraints = false;
        postTextView.translatesAutoresizingMaskIntoConstraints = false;
        upVoteButton.translatesAutoresizingMaskIntoConstraints = false;
        downVoteButton.translatesAutoresizingMaskIntoConstraints = false;
        statLabel.translatesAutoresizingMaskIntoConstraints = false;
        
        postTextView.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        postTextView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 5).isActive = true
        postTextView.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor).isActive = true
        postTextView.rightAnchor.constraint(equalTo: self.openButton.leftAnchor, constant: -5).isActive = true
        postTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 110).isActive = true
        
        
        openButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 0).isActive = true
        openButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        openButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        userLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true

        userImage.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        userImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userImage.layer.cornerRadius = 20
        userImage.layer.borderColor = UIColor.label.cgColor
        userImage.layer.borderWidth = 2
        
        upVoteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        upVoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true;
        upVoteButton.centerXAnchor.constraint(equalTo: self.userImage.centerXAnchor).isActive = true
        upVoteButton.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10).isActive = true

        downVoteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        downVoteButton.widthAnchor.constraint(equalToConstant: 30).isActive = true;
        downVoteButton.centerXAnchor.constraint(equalTo: self.userImage.centerXAnchor).isActive = true
        downVoteButton.topAnchor.constraint(equalTo: self.upVoteButton.bottomAnchor, constant: 10).isActive = true
        
        statLabel.adjustsFontSizeToFitWidth = true
        statLabel.topAnchor.constraint(equalTo: downVoteButton.bottomAnchor, constant: 2).isActive = true
        statLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        statLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        statLabel.centerXAnchor.constraint(equalTo: userImage.centerXAnchor).isActive = true
    
        
        dateLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true;
    
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    
    @objc func handleUpVote(){
        
        SVProgressHUD.show()
        
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("users").document(uid)
        
        guard let postRep = self.postRepresented else { return }
        
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
                    self.postRepresented?.disliked = false
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
                        self.postRepresented?.liked = false
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
                        self.postRepresented?.liked = true
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
                            self.postRepresented?.numberOfLiked = value
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
        
        
        
        
    }
    
    
    @objc func handleDownVote(){
        
        SVProgressHUD.show()
        
        let db = Firestore.firestore()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection("users").document(uid)
        
        guard let postRep = self.postRepresented else { return }
        
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
                    self.postRepresented?.liked = false
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
                        self.postRepresented?.disliked = false
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
                        self.postRepresented?.disliked = true
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
                            self.postRepresented?.numberOfLiked = value

                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
        }
        
        
        
        
        
    }
    
    @objc func showPost(){
        
        guard self.postRepresented != nil else { return }
        
        postToShow = self.postRepresented!
        
        showPostView()
        
        
    }
    
    func showPostView(){
        
            let postVC = PostPageViewController()
        
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController?.present(postVC, animated: true, completion: nil)


        
        
    }
    
}

extension UITextView {

    func centerVertically() {
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset
    }

}
