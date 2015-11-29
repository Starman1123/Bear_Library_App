//
//  BLBookTableViewCell.swift
//  
//
//  Created by Sheng Wang on 11/28/15.
//
//

import UIKit

class BLBookTableViewCell: UITableViewCell {

    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var bookAuthorLabel: UILabel!
    @IBOutlet var bookPublisherLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
