//
//  ViewController.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//

import UIKit
import Charts
struct DayData{
    
    var strDate = String()
    var data = [RevExpance]()
    
}


class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var viewPieChartView: PieChartView!
    
    var datePicke = UIDatePicker()
    var toolBar = UIToolbar()
    var db:DBHelper = DBHelper()
    var revExpance:[RevExpance] = []
    var total : Float = 0
    var arrayDistinctDate : [String] = []
    var totalRevenue : Float = 0.0
    var totalExpance : Float = 0.0
    
    
    
    @IBOutlet weak var srchbarFilterTableData: UISearchBar!
    var arrDayWiseData = [DayData]()
    var tmparrDayWiseData = [DayData]()
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblDisplayTotal: UILabel!
    @IBOutlet weak var sgmntRevAndExpance: UISegmentedControl!
    @IBOutlet weak var tblDataDisplay: UITableView!
    
    
    var toolbar = UIToolbar()
    var datePicker = UIDatePicker()
    
    func pieChartUpdate () {
        //future home of bar chart code
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let containerView = UIControl(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        containerView.addTarget(self, action: #selector(btnPlusActionTouchUpInside), for: .touchUpInside)
        let imageSearch = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        imageSearch.image = UIImage(named: "plus")
        containerView.addSubview(imageSearch)
        let searchBarButtonItem = UIBarButtonItem(customView: containerView)
        searchBarButtonItem.width = 20
        navigationItem.rightBarButtonItem = searchBarButtonItem
        tblDataDisplay.delegate = self
        tblDataDisplay.dataSource = self
        datePicke.datePickerMode = .dateAndTime
        datePicke.preferredDatePickerStyle = .wheels
        txtDate.inputView = datePicke
        
        var item = [UIBarButtonItem]()
        item.append(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        item.append(space)
        
        item.append(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done)))
        toolBar.items = item
        toolBar.sizeToFit()
        txtDate.inputAccessoryView = toolBar
        db.createTable()
        var str : String = "ABCDEFGHIJKLMN"
        srchbarFilterTableData.showsCancelButton = true
        srchbarFilterTableData.delegate = self
        
        
   
      
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
         arrayDistinctDate = []
         arrDayWiseData = [DayData]()
        total = 0
        
        if sgmntRevAndExpance.selectedSegmentIndex == 0
        {
            revExpance = db.readOnlyRevenueOrExpance(isRevenue: 1)
            
        }
        else
        {
            revExpance = db.readOnlyRevenueOrExpance(isRevenue: 0)
        }
        setAndCountNoOfDistinctDate()
        tblDataDisplay.reloadData()
        lblDisplayTotal.text = "\(total)"
        
        db.totalRevanue(completion: { [self] (isSuccess, sum) in
       //     db.databaseClose()
            if isSuccess{
                totalRevenue = sum
                db.totalExpance { (isSucces, sum) in
                    if isSuccess{
                        totalExpance = sum
                        pieChartInitilize()
                    }
                }
            }
        })
    }
    
    func pieChartInitilize()  {
        
  
        
        let entry1 = PieChartDataEntry(value: Double(totalRevenue), label: "Revanue" )
        let entry2 = PieChartDataEntry(value: Double(totalExpance), label: "Expance")
    
        let dataSet = PieChartDataSet(entries: [entry1, entry2], label: "Widget Types")
        dataSet.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: dataSet)
        
        viewPieChartView.data = data
        viewPieChartView.chartDescription?.text = "Revanue Expance Chart"

//        viewPieChartView.backgroundColor = UIColor.black
//        viewPieChartView.holeColor = UIColor.clear
//        viewPieChartView.chartDescription?.textColor = UIColor.white
//        viewPieChartView.legend.textColor = UIColor.white
        
        viewPieChartView.entryLabelColor = .black
       // viewPieChartView.tintColor = .red
        viewPieChartView.noDataTextColor = .red
        
          viewPieChartView.notifyDataSetChanged()
    }
    @objc func cancel()
    {
        txtDate.resignFirstResponder()
    }
    @objc func done()
    {
        txtDate.resignFirstResponder()
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.medium
        dateFormatter.dateFormat = "YYYY-MM-DD HH:MM:SS"
        txtDate.text = "\(dateFormatter.string(from: datePicke.date))"
    }
    
    @objc func btnPlusActionTouchUpInside()
    {
        if let vc = storyboard?.instantiateViewController(identifier: "REVEXaddNewReveAndExpanceViewController")as? REVEXaddNewReveAndExpanceViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrDayWiseData.count
        
    }
    
//
//    func countNumberOfRowsInSection(section: Int) -> Int {
//        var count = 0
//        for item in revExpance {
//            if (arrDayWiseData[section].strDate == ChangeDateFormate(date: item.date))
//            {
//                count += 1
//            }
//        }
//        return count
//    }
//
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arrDayWiseData[section].strDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDayWiseData[section].data.count
        //return revExpance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "REVEXcellRevExDisplayTableViewCell", for: indexPath) as! REVEXcellRevExDisplayTableViewCell
        
        let tmpDate = ChangeDateFormate(date: arrDayWiseData[indexPath.section].data[indexPath.row].date)
        cell.lbtItemName.text = arrDayWiseData[indexPath.section].data[indexPath.row].itemName
        cell.lblItemDate.text = tmpDate
        cell.lblItemAmount.text = String(arrDayWiseData[indexPath.section].data[indexPath.row].amount)
    
        lblDisplayTotal.text = "\(total)"
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red:180/255.0 ,green:138/255.0 ,blue:171/255.0,alpha:0.5)
        cell.selectedBackgroundView = bgColorView
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECDET: \(indexPath.row)")
        
        if let vc = storyboard?.instantiateViewController(identifier: "REVEXaddNewReveAndExpanceViewController")as? REVEXaddNewReveAndExpanceViewController {
            vc.revExpance?.append(arrDayWiseData[indexPath.section].data[indexPath.row])
            vc.isEditingRecord = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction =  UIContextualAction(style: .normal, title: "Delete", handler: { (action,view,completionHandler ) in
            //do stuff
            self.displayDeleteAlert { (iSsuccess) in
                if (iSsuccess)
                {
                    self.revExpance.remove(at: indexPath.row)
                    self.arrDayWiseData[indexPath.section].data.remove(at: indexPath.row)
                    self.tblDataDisplay.deleteRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: UITableView.RowAnimation.fade)
                    self.tblDataDisplay.reloadData()
                }
                completionHandler(true)
            }
        })
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor(red: 255/255, green: 52/255, blue: 52/255, alpha: 1)
        var deleteConfiguration : UISwipeActionsConfiguration
        deleteConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return deleteConfiguration
    }
    //
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 40
    //    }
    //
    
    @IBAction func sgmntActionRevExpanceValueChange(_ sender: UISegmentedControl) {
        print(sgmntRevAndExpance.selectedSegmentIndex)
        arrayDistinctDate = []
        arrDayWiseData = [DayData]()
        total = 0
       
       if sgmntRevAndExpance.selectedSegmentIndex == 0
       {
           revExpance = db.readOnlyRevenueOrExpance(isRevenue: 1)
       }
       else
       {
           revExpance = db.readOnlyRevenueOrExpance(isRevenue: 0)
       }
       setAndCountNoOfDistinctDate()
       tblDataDisplay.reloadData()
       lblDisplayTotal.text = "\(total)"
    }
    
    func ChangeDateFormate1(date: String) -> String
    {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX//
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tdate = dateFormatter.date(from:date)!
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: tdate)
        print("YEAR:\(convertedDate)")
        
        return convertedDate
    }
    
    func ChangeDateFormate(date: String) -> String
    {
        var dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX//
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
        let tdate = dateFormatter.date(from:date)!
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: tdate)
        print("YEAR:\(convertedDate)")
        
        return convertedDate
    }
    
    func setAndCountNoOfDistinctDate(){
        for item in revExpance {
            let convertedDate = ChangeDateFormate(date: item.date)
            print("INSIDE countNoOfDistinctDate=========" , item.date)
            if(arrayDistinctDate.contains(convertedDate) == false)
            {
                arrayDistinctDate.append(convertedDate)
                arrDayWiseData.append(DayData(strDate: convertedDate, data: []))
            }
        }
        //
        for data in revExpance{
            for (index,dayData) in arrDayWiseData.enumerated(){
                if ChangeDateFormate(date:  data.date)  == ChangeDateFormate1(date:  dayData.strDate){
                    arrDayWiseData[index].data.append(data)
                    total += Float(data.amount)
                }
            }
        }
    }
    
    ////////////////////////
    
    
    
    func displayDeleteAlert(completion:@escaping (Bool) -> Void){
        let alert = UIAlertController(title: "Delete Alert", message: "Are you Sure Want to Delete This?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { action in
            completion(true)
        })
        
        let cancel = UIAlertAction(title: "No", style: .default, handler: { action in
            completion(false)
        })
        alert.view.tintColor = UIColor(red: 116/255, green: 69/255, blue: 191/255, alpha: 1)
        
        alert.addAction(cancel)
        alert.addAction(ok)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        total = 0
        let filterText = srchbarFilterTableData.text
        if (filterText != "")
        {
            tmparrDayWiseData = []
            arrayDistinctDate.removeAll()
            for item in revExpance {
                let convertedDate = ChangeDateFormate(date: item.date)
                if (item.itemName.lowercased().contains((filterText?.lowercased())!) && arrayDistinctDate.contains(convertedDate) == false)
                {
                    arrayDistinctDate.append(convertedDate)
                    tmparrDayWiseData.append(DayData(strDate: convertedDate, data: []))
                }
            }
            //
            for data in revExpance{
                for (index,dayData) in tmparrDayWiseData.enumerated(){
                    if (ChangeDateFormate(date:  data.date)  == ChangeDateFormate1(date:  dayData.strDate) && data.itemName.lowercased().contains((filterText?.lowercased())!)  )  {
                        tmparrDayWiseData[index].data.append(data)
                        total += Float(data.amount)
                    }
                }
            }
            arrDayWiseData = tmparrDayWiseData
//
//            for item in arrDayWiseData {
//                print(item)
//               // print(item.data[0].itemName)
//                for a in item.data {
//                    if (a.itemName.lowercased().contains((filterText?.lowercased())!))
//                    {
//                        print("##########",a.date)
//                        tmparrDayWiseData.append(DayData(strDate: a.date, data: []))
//                    }
//                }
//            }
////            print("$$$$$$$$")
////            print(tmparrDayWiseData)
////            print("$$$$$$$")
//
//            for data in revExpance{
//                for (index,dayData) in tmparrDayWiseData.enumerated(){
//                    if data.date.contains(dayData.strDate) {
//                        tmparrDayWiseData[index].data.append(data)
//                        total += Float(data.amount)
//                    }
//                }
//            }
            
           
            
//            arrayDistinctDate = []
//            for item in revExpance {
//            print("INSIDE countNoOfDistinctDate=========" , item.date)
//            if(arrayDistinctDate.contains(convertedDate) == false)
//            {
//                arrayDistinctDate.append(convertedDate)
//                arrDayWiseData.append(DayData(strDate: convertedDate, data: []))
//            }
//
//            for data in revExpance{
//                for (index,dayData) in arrDayWiseData.enumerated(){
//                    if ChangeDateFormate(date:  data.date)  == ChangeDateFormate1(date:  dayData.strDate){
//                        arrDayWiseData[index].data.append(data)
//                        total += Float(data.amount)
//                    }
//                }
//            }]
//
        }
        else
        {
            total = 0
            arrayDistinctDate.removeAll()
            arrDayWiseData.removeAll()
           
           if sgmntRevAndExpance.selectedSegmentIndex == 0
           {
            
               revExpance = db.readOnlyRevenueOrExpance(isRevenue: 1)
               //tblDataDisplay.reloadData()
               //lblDisplayTotal.text = "\(total)"
               
           }
           else
           {
               revExpance = db.readOnlyRevenueOrExpance(isRevenue: 0)
               //tblDataDisplay.reloadData()
               //lblDisplayTotal.text = "\(total)"
           }
           setAndCountNoOfDistinctDate()
        }
        tblDataDisplay.reloadData()
        lblDisplayTotal.text = "\(total)"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        srchbarFilterTableData.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchbarFilterTableData.resignFirstResponder()
    }
    
}


