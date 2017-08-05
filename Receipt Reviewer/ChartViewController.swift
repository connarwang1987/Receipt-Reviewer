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
    var convertedArray: [Date] = []
    var monthlyTotals = [Double]()
    var tempSameMonth = [Receipt]()
    var tempTotal = 0.0
    var startYear: Int16 = 0
    var endYear: Int16 = 0
    
    @IBOutlet weak var pieView: PieChartView!
    @IBOutlet weak var tfValue: UITextField!
    @IBOutlet weak var barView: BarChartView!
    weak var axisFormatDelegate: IAxisValueFormatter?

//    func sortDated(receiptsToSort sortThis: [Receipt]) -> [Receipt] {
//        
//        let result = sortThis.sorted(by: {
//            let date0 = $0.date! as Date
//            let date1 = $1.date! as Date
//            return date0 < date1
//        })
//        print(result)
//
//        return result
//        
//    }
    
    func setChart(){
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let monthlySpenses = DataGenerator.data()
        var tempSpenses = [Double]()
        for i in 0..<monthlySpenses.count{
            tempSpenses.append(Double(monthlySpenses[i].value))
        }
        barView.setBarChartData(xValues: months, yValues: tempSpenses, label: "Monthly Expanse($)")
        barView.legend.enabled = false
        barView.scaleYEnabled = false
        barView.scaleXEnabled = false
        barView.pinchZoomEnabled = false
        barView.doubleTapToZoomEnabled = false
        barView.highlighter = nil
        barView.rightAxis.enabled = false
        barView.xAxis.drawGridLinesEnabled = false
        barView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)


    }
//    
//    func dataBuild() -> [Double]{
//        //setting end and start year
//        for r in 1..<receipts.count{
//            if receipts[r].year <= receipts[r-1].year{
//                startYear = receipts[r].year
//            }else{
//                startYear = receipts[r-1].year
//            }
//        }
//        for t in 1..<receipts.count{
//            if receipts[t].year >= receipts[t-1].year{
//                endYear = receipts[t].year
//            }else{
//                endYear = receipts[t-1].year
//            }
//        }
//        print(startYear)
//        print(endYear)
//        //the retrieve starts here
//        for y in startYear...endYear{
//            for m in 1...12{
//                tempTotal = 0.0
//                tempSameMonth = sortDated(receiptsToSort: receipts).filter {($0.month == Int16(m) ) && ($0.year == y)}
//                
//                for i in 0..<tempSameMonth.count{
//                    tempTotal += tempSameMonth[i].total
//                }
//                monthlyTotals.append(tempTotal)
//            }
//        }
//        return monthlyTotals
//    }
   
   
    
    //pie chart construction
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
        }

        var entries = [PieChartDataEntry]()
        
        for type in ReceiptType.allValues {
            if let total = typeToSum[type],
            total != 0 {
//                let entry = PieChartDataEntry.init(value: total, label: type.rawValue)
                let entry = PieChartDataEntry(value: total, label: type.rawValue)

               
                entries.append(entry)
            }
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        
        let testing = entries.count
        
        for _ in 0..<entries.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
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
        pieView.animate(yAxisDuration: 1.5, easingOption: .easeInOutQuart)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        receipts = CoreDataHelper.retrieveReceipts()
        updateChartData()
        setChart()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        axisFormatDelegate = self
        
        
        receipts = CoreDataHelper.retrieveReceipts()
        
        print(monthlyTotals.count)
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        let monthlySpenses = DataGenerator.data()
//        
//        // Initialize an array to store chart data entries (values; y axis)
//        var barEntries = [ChartDataEntry]()
//        
//        // Initialize an array to store months (labels; x axis)
//        var barMonths = [String]()
//        
//        var i = 0
//        
//        for monthlySpense in monthlySpenses {
//            // Create single chart data entry and append it to the array
////            let barEntry = BarChartDataEntry(value: monthlySpense.value, xIndex: i)
//            let barEntry = BarChartDataEntry(x: Double(i), y: monthlySpense.value)
//            barEntries.append(barEntry)
//            
//            // Append the month to the array
//            let timeIntervalForDate: TimeInterval = 1
//            barMonths.append(monthlySpense.month)
//            
//            i += 1
//        }
//        
//        // Create bar chart data set containing salesEntries
//        let chartDataSet = BarChartDataSet(values: barEntries, label: "Monthly Expense")
//        
//        // Create bar chart data with data set and array with values for x axis
////        let chartData = BarChartData(xVals: barMonths, dataSets: [chartDataSet])
//        let chartData = BarChartData(dataSets: [chartDataSet])
//        
//        // Set bar chart data to previously created data
//        barView.data = chartData
//        let formato:BarChartFormatter = BarChartFormatter()
//        let xaxis:XAxis = XAxis()
////        let xaxis = barView.xAxis
//        xaxis.valueFormatter = axisFormatDelegate
//        xaxis.labelPosition = XAxis.LabelPosition.bottom
//        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension BarChartView {
    
    private class BarChartFormatter: NSObject, IAxisValueFormatter {
        
        var labels: [String] = []
        
        func stringForValue(_ value: Double, axis: AxisBase?) -> String {
            return labels[Int(value)]
        }
        
        init(labels: [String]) {
            super.init()
            self.labels = labels
        }
    }
    
    func setBarChartData(xValues: [String], yValues: [Double], label: String) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<yValues.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: yValues[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: label)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        let chartFormatter = BarChartFormatter(labels: xValues)
        let xAxis = XAxis()
        xAxis.valueFormatter = chartFormatter
        self.xAxis.valueFormatter = xAxis.valueFormatter
        self.xAxis.labelPosition = .bottom
        self.data = chartData
    }
}
extension Date {
  
    func isInSameMonth(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
}
