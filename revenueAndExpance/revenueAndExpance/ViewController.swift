//
//  ViewController.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//

import UIKit

class ViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    var datePicke = UIDatePicker()
    var toolBar = UIToolbar()
    var db:DBHelper = DBHelper()
    var revExpance:[RevExpance] = []
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var lblItemName: UILabel!
    
    @IBOutlet weak var lblDisplayTotal: UILabel!
    @IBOutlet weak var sgmntRevAndExpance: UISegmentedControl!
    @IBOutlet weak var tblDataDisplay: UITableView!
    
    var toolbar = UIToolbar()
    var datePicker = UIDatePicker()
    
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
        
        revExpance = db.readAll()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return db.countNoOfItemInDataBase()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "REVEXcellRevExDisplayTableViewCell", for: indexPath) as! REVEXcellRevExDisplayTableViewCell
       // cell.layer.cornerRadius = 20
       // cell.lblAmountDisplay.text = revExpance[indexPath.row].
        cell.lbtItemName.text = revExpance[indexPath.row].itemName
        cell.lblItemDate.text = revExpance[indexPath.row].date
        cell.lblItemAmount.text = String(revExpance[indexPath.row].amount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    @IBAction func sgmntActionRevExpanceValueChange(_ sender: UISegmentedControl) {
    }
    
}


