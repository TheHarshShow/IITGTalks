//
//  Comments.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 25/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import Foundation

import UIKit

struct Comment {
    
    let text: String
    let datePosted: Double
    let user: String
    let username: String
    
    init(dictionary: [String: Any]){
    
        self.text = dictionary["text"] as? String ?? ""
        self.datePosted = dictionary["datePosted"] as? Double ?? 0
        self.user = dictionary["user"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    
    }
    
}

var comments = [Comment]()
