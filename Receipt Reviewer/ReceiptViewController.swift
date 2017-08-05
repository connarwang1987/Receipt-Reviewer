//
//  ViewController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/10/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ReceiptViewController: UIViewController {
    let photoHelper = RRPhotoHelper()
    var visionResponse : String?
    var textCount : Int?
    var jsonDict : [String: Int] = [:]
    var tempItemNames = [String]()
    var tempItemPrices = [String]()
    var coordinats : Int?
    var visionCoordinates1: [Int]? = nil
    var visionCoordinates2: [Int]? = nil
    var visionDescription:[String]? = nil
    let apiKey = "AIzaSyCPweDaQiAX7fnfoxi5Cx8FmS9QTEdpl24"
    let baseURL = "https://vision.googleapis.com/v1/images:annotate?key="
   
    var receipts = [Receipt]() {
        didSet {
            tableView.reloadData()
        }
    }
    var apiResponse: JSON? = nil

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        receipts = CoreDataHelper.retrieveReceipts()
        tableView.reloadData()
    }
    
    func match(){
        
        
        for i in 0..<(visionCoordinates1?.count ?? 0)
        {
            jsonDict[visionDescription![i]] = visionCoordinates1![i]
        }
        
        while (Array(jsonDict.keys).filter({ Double($0) != nil }).count > 0)
        {
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
            for i in 1..<tempLineWords.count{
                tempLineStrings.append(tempLineWords[i])
            }
            let joined = tempLineStrings.joined(separator: " ")
            
            tempItemNames.append(joined)
            print(tempLineWords)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = CoreDataHelper.retrieveReceipts()
        photoHelper.completionHandler = { (image) in
            print(image)
            VisionAPIHelper.sendImage(image: self.photoHelper.pickedImage!, onCompletion: { [unowned self] (json) in
                print(json)
                self.visionResponse = json["responses"][0]["textAnnotations"][0]["description"].stringValue
//                print(json["responses"][0]["textAnnotations"][0]["description"].stringValue)
//                self.visionCoordinates =  json["responses"][0]["textAnnotations"][0]["boundingPoly"]["vertices"][0]["y"].intValue
                self.coordinats =  json["responses"][0]["textAnnotations"][3]["boundingPoly"]["vertices"][2]["y"].intValue
                let textAnnotationsCount = json["responses"][0]["textAnnotations"].arrayValue.count
                var yCoordinatesArray1 : [Int] = []
                var yCoordinatesArray2 : [Int] = []
                var jsonDescription: [String] = []
                for k in 1..<json["responses"][0]["textAnnotations"].arrayValue.count{
                    jsonDescription.append(json["responses"][0]["textAnnotations"][k]["description"].stringValue)
                }
                for i in 1..<json["responses"][0]["textAnnotations"].arrayValue.count{
                    yCoordinatesArray1.append(json["responses"][0]["textAnnotations"][i]["boundingPoly"]["vertices"][0]["y"].intValue)
            
                    yCoordinatesArray2.append(json["responses"][0]["textAnnotations"][i]["boundingPoly"]["vertices"][2]["y"].intValue)

                }
                
                self.visionCoordinates1 = yCoordinatesArray1
                self.visionCoordinates2 = yCoordinatesArray2
                self.visionDescription = jsonDescription
                self.match()

//                call match here
                
                self.performSegue(withIdentifier: "scanReceipt", sender: nil)
                self.activityIndicator.stopAnimating()

            })
        }
        
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        print("AddButton Tapped")
        photoHelper.presentActionSheet(from: self)

    }
   
    
    @IBAction func unwindToReceiptViewController(_ segue: UIStoryboardSegue) {
        self.receipts = CoreDataHelper.retrieveReceipts()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayReceipt" {
            print("Table view cell tapped")
            
            // 1
            let indexPath = tableView.indexPathForSelectedRow!
            // 2
            let receipt = receipts[indexPath.row]
            // 3
            let ReceiptDetailViewController = segue.destination as! ReceiptDetailViewController
            // 4
            ReceiptDetailViewController.receipt = receipt
            
        }
        
        if segue.identifier == "newReceipt" {
            print("+ button tapped")
            if let navVC = segue.destination as? UINavigationController {
                if let destinationVC = navVC.topViewController as? EditViewController{
                    if let visionResponse = visionResponse {
                        destinationVC.visionResponse = visionResponse
                    }
                    if let visionCoordinates1 = visionCoordinates1{
                        destinationVC.visionCoordinates1 = visionCoordinates1
                        destinationVC.isScanningReceipt = true
                    }
                    if let visionCoordinates2 = visionCoordinates2{
                        destinationVC.visionCoordinates2 = visionCoordinates2
                    }
                    if let visionDescription = visionDescription{
                        destinationVC.visionDescription = visionDescription
                    }
                
                    if let coordinats = coordinats{
                        destinationVC.coordinats = coordinats
                    }
                    
                }
                
            }
            
        }
        if segue.identifier == "scanReceipt"{
            if let navVC = segue.destination as? UINavigationController {
                if let destinationVC = navVC.topViewController as? EditViewController{
                    destinationVC.tempItemNames = tempItemNames
                    destinationVC.tempItemPrices = tempItemPrices
                    tempItemPrices = []
                    tempItemNames = []
                }
            }
        }
    }
}




extension ReceiptViewController: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return receipts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptViewCell", for: indexPath) as! ReceiptViewCell
    
        let row = indexPath.row
        let receipt = receipts[row]

        cell.receiptNameLabel.text = receipt.title
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


