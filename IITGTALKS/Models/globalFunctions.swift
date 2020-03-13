//
//  globalFunction.swift
//  IITGTALKS
//
//  Created by Harsh Motwani on 18/12/19.
//  Copyright © 2019 Harsh Motwani. All rights reserved.
//

import UIKit

func getThreeDigits(_ x: Int)->String{
    
    var s: String = "\(x)"
    
    while(s.count < 4){
     
        s = "0"+s;
        
    }
    
    
    
    return s
    
}
