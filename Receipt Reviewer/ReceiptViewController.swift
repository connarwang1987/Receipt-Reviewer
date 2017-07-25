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
    
    let apiKey = "AIzaSyCPweDaQiAX7fnfoxi5Cx8FmS9QTEdpl24"
    let baseURL = "https://vision.googleapis.com/v1/images:annotate?key="
   
    var receipts = [Receipt]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = CoreDataHelper.retrieveReceipts()
        photoHelper.completionHandler = { (image) in
            print(image)
            VisionAPIHelper.sendImage(image: self.photoHelper.pickedImage!, onCompletion: { (json) in
                print(json)
            })
        }
//
//        let url = baseURL + apiKey
//        
//        let sampleImage = UIImage(named: "sample")
//        
//        let image = UIImageJPEGRepresentation(sampleImage!, 1.0)?.base64EncodedString()
//
//        let params: Parameters = ["requests": ["features": ["type": "LABEL_DETECTION"]], "image": ["content": image]]
//        
//        
//        
//        
//        
//        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
//            print(response)
//        }
//            
//        func base64EncodeImage(_ image: UIImage) -> String {
//            var imagedata = UIImagePNGRepresentation(image)
//            
//            if ((imagedata?.count)! > 2097152) {
//                let oldSize: CGSize = image.size
//                let newSize: CGSize = CGSize(width: 800, height: oldSize.height / oldSize.width * 800)
//                imagedata = resizeImage(newSize, image: image)
//            }
//            
//            return imagedata!.base64EncodedString(options: .endLineWithCarriageReturn)
//        }
//        
//        
//        
//        func resizeImage(_ imageSize: CGSize, image: UIImage) -> Data {
//            UIGraphicsBeginImageContext(imageSize)
//            image.draw(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height))
//            let newImage = UIGraphicsGetImageFromCurrentImageContext()
//            let resizedImage = UIImagePNGRepresentation(newImage!)
//            UIGraphicsEndImageContext()
//            return resizedImage!
//        }
//
//        let apiKey = "AIzaSyCPweDaQiAX7fnfoxi5Cx8FmS9QTEdpl24"
//        var googleURL: URL {
//            return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
//        }
//        let imageBase64 = base64EncodeImage(photoHelper.pickedImage!)
//        let paramsAsJSON: Parameters = [
//        "requests": [
//        "image": [
//        "content": imageBase64
//        ],
//        "features": [
//        [
//        "type": "TEXT_DETECTION",
//        "maxResults": 10
//        ]
//        ]
//        ]
//        ]
//        
//        let headers: HTTPHeaders = ["Content-Type": "application/json"]
//        
//        Alamofire.request(googleURL, method: .post, parameters: paramsAsJSON, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
//            print(response)
//            
//            let json = JSON(response.data)
//            
//            print(json)
//            
//        }
//        
//        
//        
        
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


