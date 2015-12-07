//
//  SearchTableViewController.swift
//  Bear-Library
//
//  Created by Sheng Wang on 12/6/15.
//  Copyright © 2015 Sheng Wang. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar!
    var bookList: Array<BLBook> = []
    var imageCache: NSCache = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "BLBookTableViewCell", bundle: nil), forCellReuseIdentifier: "BLBookTableViewCell")
        self.searchBar.delegate = self
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // || searchBar.text?.containsString(" ") != false
        if (searchBar.text?.characters.count<3) {
            bookList.removeAll()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            return
        }
        loadBooks((self.searchBar.text)!)
        
    }
    
    func loadBooks(searchText: String) {
        let originalStr = Utility.sharedInstance.searchBookURLStr + searchText
        let escapedStr = originalStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())
        Alamofire.request(.GET, NSURL(string: escapedStr!)!)
            .responseJSON { response in
                if let res = response.result.value {
                    if let results = res["results"] {
                        for i in 0..<results!.count {
                            let newBook = BLBook()
                            newBook.title = results![i]["title"] as? String
                            newBook.author = results![i]["author"] as? String
                            newBook.publisher = "Publisher: " + (results![i]["publisher"] as? String ?? "")
                            newBook.ISBN = results![i]["primary_isbn10"] as? String
                            newBook.amazonProductURLStr = (results![i]["amazon_product_url"] as? String) ?? "NoStr"
                            newBook.description = results![i]["description"] as? String
                            if let urlStr = results![i]["book_image"] {
                                newBook.imageURLStr = urlStr as? String
                            } else {
                                newBook.imageURLStr = "None"
                            }
                            self.bookList.append(newBook)
                        }
                    }
                }
                self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BLBookTableViewCell = tableView.dequeueReusableCellWithIdentifier("BLBookTableViewCell", forIndexPath: indexPath) as! BLBookTableViewCell
        var book: BLBook = BLBook()
        book = self.bookList[indexPath.row]
        cell.bookTitleLabel.text = book.title ?? ""
        cell.rankLabel.text = ""
        cell.bookAuthorLabel.text = ""
        cell.bookPublisherLabel.text = ""
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: BookDetailViewController = storyboard.instantiateViewControllerWithIdentifier("BookDetailViewController") as! BookDetailViewController
        var book: BLBook = BLBook()
        book = self.bookList[indexPath.row]
        vc.book = book
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
