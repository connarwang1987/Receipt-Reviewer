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


class EditViewController: UIViewController, EditViewCellProtocol, EditViewCellProtocolDelete {
    var items = [Item]()
    var item: Item?
    var receipt: Receipt?
    var visionResponse : String?
    var coordinats: Int?
    var visionCoordinates1 : [Int] = []
    var visionCoordinates2 : [Int] = []
    var visionDescription : [String] = []
    var isEditingReceipt = false
    var tempItemNames = [String]()
    var tempItemPrices = [String]()
    let vision = VisionAPIHelper()
    
    var jsonDict : [String: Int] = [:]
    
    
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
    
    
    func deleteCell(for row: Int) {
        tempItemPrices.remove(at: row)
        tempItemNames.remove(at: row)
        
        if row < items.count{
            CoreDataHelper.deleteItem(item: items[row])
        }
        if receipt != nil{
        self.items = CoreDataHelper.retrieveItems(withID: (receipt?.receiptID)!)
        }
        itemTable.reloadData()
    }
    
//    func match(response: String){
//        let info = response.components(separatedBy: "\n")
//        var commonIndexes: [Int] = []
//        for i in 0..<visionCoordinates1.count{
//            
//            // for coord in visionCoord
//            //      if visionCoord[i] - 10 < coord && coord < visionCoord[i] + 10
//            
//            for count in 1...10{
//                var potentialValue = visionCoordinates1[i] - 5
//                for l in 0..<visionCoordinates1.count-1{
//                    if potentialValue == visionCoordinates1[l]{
//                        commonIndexes.append(l)
//                    }
//                }
//                potentialValue += 1
//            }
//            for k in 0..<commonIndexes.count-1{
//                if let _ = Double(info[commonIndexes[k]])
//                {
//                    tempItemPrices.append(info[commonIndexes[k]])
//                    
//                }
//                else if String(info[commonIndexes[k]].characters.first!) == "$"
//                {
//                    let index = info[commonIndexes[k]].index(info[commonIndexes[k]].startIndex, offsetBy: 1)
//                    tempItemPrices.append(info[commonIndexes[k]].substring(from: index))
//                }
//                else
//                {
//                    tempItemNames.append(String(info[commonIndexes[k]]))
//                }
//
//            }
//        }
//            
//        
//
//    }
//    
    func match(){
        
        while (Array(jsonDict.keys).filter({ Double($0) != nil }).count > 0) {
            var tempLineWords : [String] = []
            
            // find $ or double
            let dollarOrDouble = Array(jsonDict.keys).first(where: { Double($0) != nil || $0.contains("$") })
            let dollarOrDoubleY = jsonDict[dollarOrDouble!]!
            jsonDict.removeValue(forKey: dollarOrDouble!)
            tempLineWords.append(dollarOrDouble!)

            // find all words with similar y
            for (key, value) in jsonDict {
                if dollarOrDoubleY - 10  < value && value < dollarOrDoubleY + 10 {
                    tempLineWords.append(key)
                    jsonDict.removeValue(forKey: key)
                    
                }
            }

                tempItemPrices.append(tempLineWords[0])
            var tempLineStrings: [String] = []
            for i in 1..<tempLineWords.count-1{
                tempLineStrings.append(tempLineWords[i])
            }
                let joined = tempLineStrings.joined(separator: " ")

                tempItemNames.append(joined)
            print(tempLineWords)
        }
    
        
        
    }
    
    
//    func match2(){
//        for i in 0..<visionDescription.count-1{
//            //if let num = Double(..) {..}
//            if let num = Double(visionDescription[i]) || String(visionDescription[i].characters.first!) == "$"{
//                for k in 0..<visionCoordinates1.count-1{
//                    var tempLineWords : [String] = []
//                    if (visionCoordinates1[i] - 5) < visionCoordinates1[k] && visionCoordinates1[k] < (visionCoordinates1[i] + 5) {
//                        if visionDescription[k] == visionDescription[i]{
//                            tempLineWords.append(visionDescription[k])
//                        }
//                        tempItemNames.append(tempLineWords.joined(separator: " "))
//                        if String(visionDescription[i].characters.first!) == "$"{
////                            tempItemPrices.append(visionDescription[i].remove(at: k))
//                            tempItemPrices.append(visionDescription[i].trimmingCharacters(in: CharacterSet(charactersIn: "$")))
//                        }else{
//                            tempItemPrices.append(visionDescription[i])
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dump (visionCoordinates1)
        dump (visionCoordinates2)
        dump (visionDescription)
        for i in 0..<(visionCoordinates1.count) {
            jsonDict[visionDescription[i]] = visionCoordinates1[i]
        }
        
        
        if isEditingReceipt {
            receiptTitleTextField.text = receipt!.title
            
            self.items = CoreDataHelper.retrieveItems(withID: (receipt?.receiptID)!)
            for j in 0..<items.count {
                tempItemNames.append(items[j].name!)
                tempItemPrices.append(String(items[j].price))
                self.itemTable.reloadData()
                
                
            }
        }
                if !isEditingReceipt{
                    if visionResponse != nil{
                        match()
                    }
                }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        if !receiptTitleTextField.text!.isEmpty{
            
            if tempItemNames.isEmpty {
                return
            }
//            if !isEditingReceipt && vision.apiResponse[0] != nil{
            
            
            if !isEditingReceipt{
                
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
            }else{
                //
                
                for k in items.count..<tempItemNames.count{
                    let item = CoreDataHelper.newItem()
                    item.name = tempItemNames[k]
                    item.price = Double(tempItemPrices[k])!
                    item.itemID = receipt?.receiptID
                    CoreDataHelper.saveItem()
                }
                    dismiss(animated: true, completion: nil)

                

            }
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
            itemCell.deleteDelegate = self
            itemCell.row = row
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
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Cell Tapped")
    }
    
}



