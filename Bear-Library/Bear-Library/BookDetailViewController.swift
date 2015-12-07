//
//  BookDetailViewController.swift
//  Bear-Library
//
//  Created by Sheng Wang on 12/5/15.
//  Copyright © 2015 Sheng Wang. All rights reserved.
//

import UIKit
import CoreData

class BookDetailViewController: UIViewController {
    
    @IBOutlet var bookImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var publisherLabel: UILabel!
    
    @IBOutlet var ISBNLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var buyOnAmazonButton: UIButton!
    
    @IBOutlet var addToLibraryButton: UIButton!
    
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
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
    
    override func viewWillAppear(animated: Bool) {
        if bookAlreadyInList() == true {
            self.addToLibraryButton.backgroundColor = UIColor.grayColor()
            addToLibraryButton.userInteractionEnabled = false
            addToLibraryButton.setTitle("Already in Library", forState: .Normal)
        } else {
            self.addToLibraryButton.backgroundColor = UIColor(red: 27/255.0, green: 201/255.0, blue: 140/255.0, alpha: 1.0)
            addToLibraryButton.userInteractionEnabled = true
            addToLibraryButton.setTitle("Add to Library", forState: .Normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buyBookOnAmazon(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: book.amazonProductURLStr!)!)
    }
    
    func bookAlreadyInList() -> Bool {
        var exists = false
        let libraryFetch = NSFetchRequest(entityName: "Book")
        libraryFetch.predicate = NSPredicate(format: "isbn == %@", (book.ISBN)!)
        do {
            let fetchedList = try moc.executeFetchRequest(libraryFetch)
            let mocarray = fetchedList as! [NSManagedObject]
            if mocarray.count > 0 {
                exists = true
            }
            
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
        return exists
    }
    
    @IBAction func addToLibrary(sender: UIButton) {
        let entity = NSEntityDescription.entityForName("Book", inManagedObjectContext:moc)
        let libraryFetch = NSFetchRequest(entityName: "Book")
        libraryFetch.predicate = NSPredicate(format: "isbn == %@", (book.ISBN)!)
        
        if bookAlreadyInList() == false {
            let bookToAdd = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: moc)
            bookToAdd.setValue(book.title, forKey: "title")
            bookToAdd.setValue(book.ISBN, forKey: "isbn")
            bookToAdd.setValue(book.rank, forKey: "rank")
            bookToAdd.setValue(book.imageURLStr, forKey: "imageURLStr")
            bookToAdd.setValue(book.publisher, forKey: "publisher")
            bookToAdd.setValue(book.amazonProductURLStr, forKey: "amazonProductURLStr")
            bookToAdd.setValue(book.description, forKey: "desc")
            bookToAdd.setValue(book.author, forKey: "author")
        }
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save managed object context: \(error)")
        }
        
        self.addToLibraryButton.backgroundColor = UIColor.grayColor()
        addToLibraryButton.userInteractionEnabled = false
        addToLibraryButton.setTitle("Already in Library", forState: .Normal)
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
