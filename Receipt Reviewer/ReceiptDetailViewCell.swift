//
//  ReceiptDetailTableViewCell.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/11/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit

class ReceiptDetailViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
       
    

    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    


}
