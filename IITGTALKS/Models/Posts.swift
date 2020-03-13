//
//  Posts.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 13/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

struct Post {
    
    let url: String
    let datePosted: Double
    let postIndex: String
    var numberOfLiked: Int
    let user: String
    var userImage: String
    let name: String
    var liked: Bool
    var disliked: Bool
    var indexShown: Int
    var numberOfComments: Int
    
    init(dictionary: [String: Any]){
        
        self.url = dictionary["URL"] as? String ?? ""
        self.datePosted = dictionary["datePosted"] as? Double ?? 0
        self.postIndex = dictionary["postIndex"] as? String ?? ""
        self.numberOfLiked = dictionary["numberOfLiked"] as? Int ?? 0
        self.user = dictionary["user"] as? String ?? ""
        self.userImage = dictionary["profilePictureURL"] as? String ?? ""
        self.name = dictionary["username"] as? String ?? ""
        self.liked = dictionary["liked"] as? Bool ?? false
        self.indexShown = dictionary["indexShown"] as? Int ?? 0
        self.disliked = dictionary["disliked"] as? Bool ?? false
        self.numberOfComments = dictionary["numberOfComments"] as? Int ?? 0
    }
    
}

var posts: [Post] = {
   
    let dict = [Post]()
    return dict
    
}()

var postToShow = Post(dictionary: [:])
