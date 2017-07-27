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
    var coordinats : Int?
    var visionCoordinates: [Int]? = nil
    let apiKey = "AIzaSyCPweDaQiAX7fnfoxi5Cx8FmS9QTEdpl24"
    let baseURL = "https://vision.googleapis.com/v1/images:annotate?key="
   
    var receipts = [Receipt]() {
        didSet {
            tableView.reloadData()
        }
    }
    var apiResponse: JSON? = nil

    @IBOutlet weak var tableView: UITableView!
    
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
                for i in 1..<json["responses"][0]["textAnnotations"].arrayValue.count{
                    yCoordinatesArray1.append(json["responses"][0]["textAnnotations"][i]["boundingPoly"]["vertices"][0]["y"].intValue)
            
                    yCoordinatesArray2.append(json["responses"][0]["textAnnotations"][i]["boundingPoly"]["vertices"][2]["y"].intValue)

                }
                
                self.visionCoordinates = yCoordinatesArray1
                
                self.performSegue(withIdentifier: "newReceipt", sender: nil)
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
                    destinationVC.delegate = self
                    if let visionResponse = visionResponse {
                        destinationVC.visionResponse = visionResponse
                    }
                    if let visionCoordinates = visionCoordinates{
                        destinationVC.visionCoordinates = visionCoordinates
                    }
                    if let coordinats = coordinats{
                        destinationVC.coordinats = coordinats
                    }
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

extension ReceiptViewController: EditViewControllerProtocol{
    func reloadTableView() {
        receipts = CoreDataHelper.retrieveReceipts()
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


