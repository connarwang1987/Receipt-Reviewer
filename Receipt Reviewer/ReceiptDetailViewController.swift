//
//  ReceiptDetailViewController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 7/11/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Foundation


class ReceiptDetailViewController: UIViewController {
    var receipt: Receipt?

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    
        

    
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 1
        if let receipt = receipt {
            // 2
            titleText.text = receipt.title
            dateText.text = receipt.date?.convertToString()
        } else {
            // 3
            titleText.text = ""
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load")
               // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ReceiptViewController = segue.destination as! ReceiptViewController
        print("ReceiptViewController = \(ReceiptViewController)")

        if segue.identifier == "save" {

            if let receipt = receipt {
                // 1
                receipt.title = titleText.text ?? ""
                // 2
                print("text load \(String(describing: receipt.title))")
                ReceiptViewController.tableView.reloadData()
                
            } else {
                // 3
                let receipt = self.receipt ?? CoreDataHelper.newReceipt()
                print("receipt = \(receipt)")
                receipt.title = titleText.text ?? ""
                receipt.date = Date() as NSDate
                CoreDataHelper.saveReceipt()
            }
        }
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    }

extension ReceiptDetailViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
            print("tableView = \(tableView)")
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // 3
        let cell = tableView.dequeueReusableCell(withIdentifier: "receiptDetailViewCell", for: indexPath) as! ReceiptDetailViewCell
        print("Cell = \(cell)")
        // 2

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Cell Tapped")
    }

}








