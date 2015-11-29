//
//  Utility.swift
//  Bear-Library
//
//  Created by Sheng Wang on 11/28/15.
//  Copyright © 2015 Sheng Wang. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    static let sharedInstance = Utility()
    
    
    let themeColor: UIColor = UIColor(red: 50/255.0, green: 80/255.0, blue: 109/255.0, alpha: 1.0)
    let titleTextFont: UIFont = UIFont(name: "Didot", size: 23.0)!
    let tabBarTitleTextFont: UIFont = UIFont(name: "Didot", size: 13.0)!
    let getTopFictionURL: NSURL = NSURL(string: "https://api.nytimes.com/svc/books/v3/lists/hardcover-fiction.json?api-key=7797e2d29bd1604f89df9a1bea3085b4:17:73611604")!
    let getTopNonfictionURL: NSURL = NSURL(string: "https://api.nytimes.com/svc/books/v3/lists/hardcover-nonfiction.json?api-key=7797e2d29bd1604f89df9a1bea3085b4:17:73611604")!
    init() {
        
    }
}