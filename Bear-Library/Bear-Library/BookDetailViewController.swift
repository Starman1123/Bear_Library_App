//
//  BookDetailViewController.swift
//  Bear-Library
//
//  Created by Sheng Wang on 12/5/15.
//  Copyright © 2015 Sheng Wang. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet var bookImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var publisherLabel: UILabel!
    
    @IBOutlet var ISBNLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var buyOnAmazonButton: UIButton!
    
    @IBOutlet var addToLibraryButton: UIButton!
    
    
    var book: BLBook!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.titleLabel.text = book.title
        self.authorLabel.text = book.author
        self.ISBNLabel.text = book.ISBN
        self.descriptionLabel.text = "Book description: " + book.description!
        
        if let _ = book.imageURLStr {
            dispatch_async(dispatch_get_global_queue(0, 0)) { () -> Void in
                let image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.book.imageURLStr!)!)!)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.bookImageView.image = image
                })
            }
        } else {
            self.bookImageView.image = UIImage(named: "default_image.jpg")
        }
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyBookOnAmazon(sender: UIButton) {
        print("Buy Book On Amazon")
        UIApplication.sharedApplication().openURL(NSURL(string: book.amazonProductURLStr!)!)
    }
    
    @IBAction func addToLibrary(sender: UIButton) {
        print("Add to Library")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
