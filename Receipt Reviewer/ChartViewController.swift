//
//  ChartViewController.swift
//  Receipt Reviewer
//
//  Created by Linglong Wang on 8/1/17.
//  Copyright © 2017 Connar Wang. All rights reserved.
//

import UIKit
import Charts
import RealmSwift


class ChartViewController: UIViewController {
    var receipt: Receipt?
    var receipts = [Receipt]()
    
    
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var barView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    
    
    @IBAction func btnButtonTapped(_ sender: Any) {
        if let value = tfValue.text , value != "" {
            let visitorCount = VisitorCount()
            visitorCount.count = (NumberFormatter().number(from: value)?.intValue)!
            visitorCount.save()
            tfValue.text = ""
        }
        updateChartWithData()
        
    }
    
    func getVisitorCountsFromDatabase() -> Results<VisitorCount> {
        do {
            let realm = try Realm()
            return realm.objects(VisitorCount.self)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateChartWithData() {
        var dataEntries: [BarChartDataEntry] = []
        
        let visitorCounts = getVisitorCountsFromDatabase()
        
        for i in 0..<visitorCounts.count {
            let timeIntervalForDate: TimeInterval = visitorCounts[i].date.timeIntervalSince1970
            let dataEntry = BarChartDataEntry(x: Double(timeIntervalForDate), y: Double(visitorCounts[i].count))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        barView.data = chartData
        
        let xaxis = barView.xAxis
        xaxis.valueFormatter = axisFormatDelegate
    }
    
    
    func updateChartData()  {
        // 2. generate chart data entries
        var typeToSum: [ReceiptType: Double] = [:]
        for type in ReceiptType.allValues {
            typeToSum[type] = 0.0
        }
        
        for receipt in receipts {
            guard let typeString = receipt.type,
            let type = ReceiptType(rawValue: typeString) else {
                print("Error converting receipt.type to enum ReceiptType value ")
                break
            }
            typeToSum[type]! += receipt.total
            print(typeString)
        }

        var entries = [PieChartDataEntry]()
        
        for type in ReceiptType.allValues {
            if let total = typeToSum[type],
            total != 0 {
                print(total)
//                let entry = PieChartDataEntry.init(value: total, label: type.rawValue)
                let entry = PieChartDataEntry(value: total, label: type.rawValue)

                print(entry)
                print(total)
                entries.append(entry)
            }
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        
        let testing = entries.count
        print(testing)
        
        for _ in 0..<entries.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            print(color)
            
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieView.data = data
        pieView.noDataText = "No data available"
        // user interaction
        pieView.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = ""
        pieView.chartDescription = d
        pieView.centerText = ""
        pieView.holeRadiusPercent = 0.2
        pieView.transparentCircleColor = UIColor.clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        axisFormatDelegate = self
        updateChartData()
        updateChartWithData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        receipts = CoreDataHelper.retrieveReceipts()
        for i in 0..<receipts.count{
            print(receipts[i].type)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension ChartViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm.ss"
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
