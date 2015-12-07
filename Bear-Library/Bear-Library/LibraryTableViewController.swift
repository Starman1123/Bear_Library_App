//
//  LibraryTableViewController.swift
//  Bear-Library
//
//  Created by Franklin Rice on 12/6/15.
//  Copyright © 2015 Sheng Wang. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: UITableViewController {

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var mocarray: [NSManagedObject] = []
    var bookList: Array<BLBook> = []
    var imageCache: NSCache = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView.registerClass(BLBookTableViewCell.self, forCellReuseIdentifier: "BLBookTableViewCell")
        setUpTableViews()
        loadFavoriteBooks()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadFavoriteBooks()
        self.tableView.reloadData()
    }
    
    func setUpTableViews() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "BLBookTableViewCell", bundle: nil), forCellReuseIdentifier: "BLBookTableViewCell")
    }
    
    func loadFavoriteBooks() {
        
        let libraryFetch = NSFetchRequest(entityName: "Book")
        
        do {
            let fetchedList = try moc.executeFetchRequest(libraryFetch)
            mocarray = fetchedList as! [NSManagedObject]
            bookList = []
            for obj in mocarray {
                let book = BLBook()
                book.author = obj.valueForKey("author") as? String
                book.title = obj.valueForKey("title") as? String
                book.imageURLStr = obj.valueForKey("imageURLStr") as? String
                book.ISBN = obj.valueForKey("isbn") as? String
                book.description = obj.valueForKey("desc") as? String
                book.amazonProductURLStr = obj.valueForKey("amazonProductURLStr") as? String
                book.rank = ""
                book.publisher = obj.valueForKey("publisher") as? String
                bookList.append(book)
            }
        } catch {
            fatalError("Failed to fetch books: \(error)")
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BLBookTableViewCell = tableView.dequeueReusableCellWithIdentifier("BLBookTableViewCell", forIndexPath: indexPath) as! BLBookTableViewCell
        let book = self.bookList[indexPath.row]
        
        cell.rankLabel.text = ""
        cell.bookTitleLabel.text = book.title
        cell.bookAuthorLabel.text = book.author
        cell.bookPublisherLabel.text = book.publisher
        if let _ = book.imageURLStr {
            if (self.imageCache.objectForKey(book.imageURLStr!) != nil) {
                cell.bookImageView.image = self.imageCache.objectForKey(book.imageURLStr!) as? UIImage
            } else {
                cell.bookImageView.image = nil
                _ = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: book.imageURLStr ?? " ")!) {
                    (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    if error == nil {
                        dispatch_async(dispatch_get_main_queue(), {
                            cell.bookImageView.image = UIImage(data: data!)
                            self.imageCache.setObject(UIImage(data: data!)!, forKey: book.imageURLStr!)
                            cell.setNeedsLayout()
                        })
                    }
                    }.resume()
            }
        } else {
            cell.bookImageView.image = UIImage(named: "default_image.jpg")
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: BookDetailViewController = storyboard.instantiateViewControllerWithIdentifier("BookDetailViewController") as! BookDetailViewController
        var book: BLBook = BLBook()
        book = self.bookList[indexPath.row]
        vc.book = book
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            let row = indexPath.row
            self.bookList.removeAtIndex(row)
            moc.deleteObject(mocarray[row])
            self.mocarray.removeAtIndex(row)
            do {
               try moc.save()
            } catch {
                fatalError("Failure to save managed object context after deletion: \(error)")
            }
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
