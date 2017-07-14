//
//  ViewController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/10/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation

class ReceiptViewController: UIViewController {
    let photoHelper = RRPhotoHelper()
   
    var receipts = [Receipt]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = CoreDataHelper.retrieveReceipts()

        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("AddButton Tapped")
        photoHelper.presentActionSheet(from: self)
    }
   
    
    @IBAction func unwindToListNotesViewController(_ segue: UIStoryboardSegue) {
        
        self.receipts = CoreDataHelper.retrieveReceipts()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayReceipt" {
                print("Table view cell tapped")
                
                // 1
                let indexPath = tableView.indexPathForSelectedRow!
                // 2
                let receipt = receipts[indexPath.row]
                // 3
                let ReceiptDetailViewController = segue.destination as! ReceiptDetailViewController
                // 4
                ReceiptDetailViewController.receipt = receipt
                
            } else if identifier == "add" {
                print("+ button tapped")
            }
        }
    }
}




extension ReceiptViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptViewCell", for: indexPath) as! ReceiptViewCell
        
        // 2
        
        let row = indexPath.row
        
        // 2
        let receipt = receipts[row]
        
        // 3
        cell.receiptNameLabel.text = receipt.title
        
        // 4
        cell.dateLabel.text = receipt.date?.convertToString()
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 2
        if editingStyle == .delete {
            // 3
            CoreDataHelper.delete(receipt: receipts[indexPath.row])
            //2
            receipts = CoreDataHelper.retrieveReceipts()        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Cell Tapped")
    }
}

extension Date {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: self, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}

extension NSDate {
    func convertToString() -> String {
        return DateFormatter.localizedString(from: (self as Date), dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.medium)
    }
}


