//
//  CommentsTableViewCell.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 25/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class CommentsTableViewCell: UITableViewCell {
    
    let userLabel: UILabel = {
        
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 200))
        label.textColor = .secondaryLabel
        label.text = "user"
        return label
        
    }()
    
    let commentTextView: UITextView = {
        
        let tv = UITextView()
        tv.isEditable = false
        tv.font = UIFont.systemFont(ofSize: 14)
        tv.textColor = .placeholderText
        
        return tv;
        
        
    }()
    
    let dateLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Posted on: \(Date())"
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .tertiaryLabel
        
        return label
        
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
               
        self.contentView.isUserInteractionEnabled = true;
        
        setupContentView()
        
        
    }
    
    
    func setupContentView(){
        
        self.contentView.addSubview(userLabel)
        self.contentView.addSubview(commentTextView)
        self.contentView.addSubview(dateLabel)
        
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        userLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        userLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        userLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        adjustUITextViewHeight(arg: commentTextView)
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        commentTextView.topAnchor.constraint(equalTo: self.userLabel.bottomAnchor, constant: 0).isActive = true
        commentTextView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        commentTextView.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant:0).isActive = true
        commentTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5).isActive = true
        commentTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40).isActive = true
        
        dateLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 15).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: 0).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
    }
    
    
    
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        arg.translatesAutoresizingMaskIntoConstraints = true
        arg.sizeToFit()
        arg.isScrollEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

