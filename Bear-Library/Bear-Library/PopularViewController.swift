//
//  PopularViewController.swift
//  
//
//  Created by Sheng Wang on 11/28/15.
//
//

import UIKit
import Alamofire

class PopularViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var fictionTableView: UITableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
    var nonfictionTableView: UITableView = UITableView(frame: UIScreen.mainScreen().bounds, style: UITableViewStyle.Plain)
    var fictionBookList: Array<BLBook> = []
    var nonfictionBookList: Array<BLBook> = []
    var imageCache: NSCache = NSCache()
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableViews()
        getBooksFromNewYorkTimesAPI()
        configureSegmentedControl()
    }
    
    func setUpTableViews() {
        fictionTableView.delegate = self
        fictionTableView.dataSource = self
        fictionTableView.tag = 0
        fictionTableView.registerNib(UINib(nibName: "BLBookTableViewCell", bundle: nil), forCellReuseIdentifier: "BLBookTableViewCell")
        fictionTableView.tableFooterView = UIView()
        fictionTableView.contentInset = UIEdgeInsetsMake(60,0,55,0)
        nonfictionTableView.delegate = self
        nonfictionTableView.dataSource = self
        nonfictionTableView.tag = 1
        nonfictionTableView.registerNib(UINib(nibName: "BLBookTableViewCell", bundle: nil), forCellReuseIdentifier: "BLBookTableViewCell")
        nonfictionTableView.tableFooterView = UIView()
        nonfictionTableView.contentInset = UIEdgeInsetsMake(60,0,55,0)
        fictionTableView.hidden = false
        nonfictionTableView.hidden = true
        self.view.addSubview(fictionTableView)
        self.view.addSubview(nonfictionTableView)
    }
    
    func configureSegmentedControl() {
        self.segmentedControl.addTarget(self, action: Selector("segmentedControlTapped"), forControlEvents: .ValueChanged)
    }
    
    func getBooksFromNewYorkTimesAPI() {
        Alamofire.request(.GET, Utility.sharedInstance.getTopFictionURL)
            .responseJSON { response in
                if let res = response.result.value {
                    if let results = res["results"] {
                        if let bookList = results!["books"] {
                            for i in 0..<bookList!.count {
                                let newBook = BLBook()
                                newBook.title = bookList![i]["title"] as? String
                                newBook.author = bookList![i]["author"] as? String
                                newBook.rank = String(bookList![i]["rank"]!!)
                                newBook.publisher = "Publisher: " + (bookList![i]["publisher"] as? String)!
                                newBook.ISBN = bookList![i]["primary_isbn10"] as? String
                                newBook.amazonProductURLStr = (bookList![i]["amazon_product_url"] as? String) ?? "NoStr"
                                newBook.description = bookList![i]["description"] as? String
                                if let urlStr = bookList![i]["book_image"] {
                                    newBook.imageURLStr = urlStr as? String
                                } else {
                                    newBook.imageURLStr = "None"
                                }
                                self.fictionBookList.append(newBook)
                            }
                        }
                    }
                }
                self.fictionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        
        Alamofire.request(.GET, Utility.sharedInstance.getTopNonfictionURL)
            .responseJSON { response in
                if let res = response.result.value {
                    if let results = res["results"] {
                        if let bookList = results!["books"] {
                            for i in 0..<bookList!.count {
                                let newBook = BLBook()
                                newBook.title = bookList![i]["title"] as? String
                                newBook.author = bookList![i]["author"] as? String
                                newBook.rank = String(bookList![i]["rank"]!!)
                                newBook.publisher = "Publisher: " + (bookList![i]["publisher"] as? String)!
                                newBook.ISBN = bookList![i]["primary_isbn10"] as? String
                                newBook.amazonProductURLStr = (bookList![i]["amazon_product_url"] as? String) ?? "NoStr"
                                newBook.description = bookList![i]["description"] as? String
                                if let urlStr = bookList![i]["book_image"] {
                                    newBook.imageURLStr = urlStr as? String
                                } else {
                                    newBook.imageURLStr = "None"
                                }
                                self.nonfictionBookList.append(newBook)
                            }
                        }
                    }
                }
                self.nonfictionTableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 0:
            return self.fictionBookList.count
        case 1:
            return self.nonfictionBookList.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: BLBookTableViewCell = tableView.dequeueReusableCellWithIdentifier("BLBookTableViewCell", forIndexPath: indexPath) as! BLBookTableViewCell
        var book: BLBook = BLBook()
        if tableView.tag == 0 {
            book = self.fictionBookList[indexPath.row]
        } else {
            book = self.nonfictionBookList[indexPath.row]
        }
        cell.rankLabel.text = book.rank
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard :UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: BookDetailViewController = storyboard.instantiateViewControllerWithIdentifier("BookDetailViewController") as! BookDetailViewController
        var book: BLBook = BLBook()
        if tableView.tag == 0 {
            book = self.fictionBookList[indexPath.row]
        } else {
            book = self.nonfictionBookList[indexPath.row]
        }
        vc.book = book
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func segmentedControlTapped() {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.fictionTableView.hidden = false
            self.nonfictionTableView.hidden = true
        } else {
            self.nonfictionTableView.hidden = false
            self.fictionTableView.hidden = true
        }
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
