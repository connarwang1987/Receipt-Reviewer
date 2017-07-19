//
//  EditViewCell.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/14/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit

protocol EditViewCellProtocol: class {
    func editNameTextField(_ text: String, on cell: EditViewCell)
    func editPriceTextField(_ text: String, on cell: EditViewCell)

}

class EditViewCell: UITableViewCell {
    
    var items = [Item]() 
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!
    
    weak var delegate: EditViewCellProtocol?
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func itemNameChanged(_ sender: UITextField) {
        delegate?.editNameTextField(sender.text ?? "", on: self)
    }
    
    @IBAction func itemPriceChanged(_ sender: UITextField) {
        delegate?.editPriceTextField(sender.text ?? "", on: self)
    }
    
    
    
    override func awakeFromNib() {
       
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
