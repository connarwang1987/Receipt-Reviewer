//
//  EditViewController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/14/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation

protocol EditViewControllerProtocol: class {
    func reloadTableView()
}


class EditViewController: UIViewController, EditViewCellProtocol {
    var items = [Item]()
    var item: Item?
    var receipt: Receipt?
    var isEditingReceipt = false
    var tempItemNames = [String]()
    var tempItemPrices = [String]()
    
    weak var delegate: EditViewControllerProtocol?
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var receiptTitleTextField: UITextField!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        print("delete")
    }
    
    @IBOutlet weak var itemTable: UITableView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        tempItemNames.append("")
        tempItemPrices.append("")
        self.itemTable.reloadData()

        
//        let item = CoreDataHelper.newItem()
//        item.itemID = receipt?.receiptID
//        items.append(item)
//        itemTable.reloadData()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEditingReceipt {
            receiptTitleTextField.text = receipt!.title
            
            self.items = CoreDataHelper.retrieveItems(withID: (receipt?.receiptID)!)
            for j in 0..<items.count {
                tempItemNames.append(items[j].name!)
                tempItemPrices.append(String(items[j].price))
                self.itemTable.reloadData()
                
                
            }
            
            
            
            
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if !receiptTitleTextField.text!.isEmpty{
            
            if tempItemNames.isEmpty {
                return
            }

            //checking if labels are empty and if price can be convert to double
            for i in 0..<tempItemNames.count {
                if tempItemNames[i].isEmpty{
                    print("empty label")
                    return
                }
                
                if let _ = Double(tempItemPrices[i]) {
                    continue
                } else{
                    print("not a valid double")
                    return
                }
            }
            
            let receipt = CoreDataHelper.newReceipt()
            receipt.title = receiptTitleTextField.text
            receipt.receiptID = UUID().uuidString
            receipt.date = NSDate()
            CoreDataHelper.saveReceipt()
            
            for k in 0..<tempItemNames.count{
                let item = CoreDataHelper.newItem()
                item.name = tempItemNames[k]
                item.price = Double(tempItemPrices[k])!
                item.itemID = receipt.receiptID
                CoreDataHelper.saveItem()
            }
            
            delegate?.reloadTableView()
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
    func editNameTextField(_ text: String, on cell: EditViewCell) {
        let index = itemTable.indexPath(for: cell)?.row
        tempItemNames[index!] = text
    }
    
    func editPriceTextField(_ text: String, on cell: EditViewCell){
        let index = itemTable.indexPath(for: cell)?.row
        tempItemPrices[index!] = text
    }
    
}





extension EditViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("tableView = \(tableView)")
        return tempItemNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = indexPath.row
        
        if row != tempItemNames.count {
            let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! EditViewCell
            itemCell.selectionStyle = .none
            
            itemCell.delegate = self
            
            itemCell.itemNameTextField.text = tempItemNames[row]
            itemCell.itemPriceTextField.text = tempItemPrices[row]
            
            return itemCell
        }
        
        let addCell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! AddCell
        addCell.selectionStyle = .none
        return addCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // 2
        if editingStyle == .delete {
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Cell Tapped")
    }
    
}



