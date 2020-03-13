//
//  MainTabBarController.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 09/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.firstIndex(of: viewController)
        if(index == 2){
            
            let uploadViewController = UploadViewController()
            present(uploadViewController, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        if Auth.auth().currentUser == nil {

            DispatchQueue.main.async {
                let loginViewController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginViewController)
                navController.isModalInPresentation = true
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }


            return

        }
            
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (document, err) in
            
            if let err = err {
                
                print("could't fetch username", err)
                return
                
            }
            
            guard let docdata = document?.data() else { return }
            
            currentUserUsername = docdata["username"] as? String ?? "username"
            NUMBER_OF_POSTS=docdata["numberOfPosts"] as? Int ?? 0
            NUMBER_OF_FOLLOWERS = docdata["numberOfFollowers"] as? Int ?? 0
            print("currentUserUsername", currentUserUsername)
            
        }
            
            
                
            
        
        
        
        
        
        setupViewControllers()
    }
    
    func setupViewControllers(){
        
        //home
        let homeViewController = UIViewController()
        homeViewController.view.backgroundColor = .systemBackground
        let homeNavController = UINavigationController(rootViewController: homeViewController)
        homeNavController.tabBarItem.image = UIImage(named: "castle")
        homeNavController.tabBarItem.selectedImage = UIImage(named: "castleSelected")
        
        //search
        let searchViewController = UITableViewController()
        let searchNavController = UINavigationController(rootViewController: searchViewController)
        searchNavController.tabBarItem.image = UIImage(named: "search")
        searchNavController.tabBarItem.selectedImage = UIImage(named: "searchSelected")
        
        //upload
        let uploadViewController = UIViewController()
        uploadViewController.view.backgroundColor = .systemBackground
        let uploadNavController = UINavigationController(rootViewController: uploadViewController)
        uploadNavController.tabBarItem.image = UIImage(named: "upload")
        
        
        //profile
        let profileViewController = ProfileViewController();

        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let profileNavController = UINavigationController(rootViewController: profileViewController)
        
        profileNavController.tabBarItem.image = UIImage(named: "crown")
        profileNavController.tabBarItem.selectedImage = UIImage(named: "CrownSelected")
        
        tabBar.tintColor = .label
        
        tabBar.backgroundColor = .tertiarySystemBackground
        
        tabBar.isTranslucent = false
        
        viewControllers = [homeNavController, searchNavController, uploadNavController, profileNavController]
        
        guard let tabBarItems = tabBar.items else { return }
        
        for item in tabBarItems {
            
            item.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
            
        }
        
        
    }
    

}
