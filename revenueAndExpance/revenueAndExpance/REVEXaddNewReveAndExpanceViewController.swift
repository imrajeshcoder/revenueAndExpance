//
//  REVEXaddNewReveAndExpanceViewController.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//

import UIKit

class REVEXaddNewReveAndExpanceViewController: UIViewController {
    var datePicke = UIDatePicker()
    var toolBar = UIToolbar()
    let cellReuseIdentifier = "REVEXcellRevExDisplayTableViewCell"
    var db:DBHelper = DBHelper()
    var isRevenue : Int = 1
    var revExpance:[RevExpance]? = []
    var isEditingRecord = false
    @IBOutlet weak var btnrevenue: UIButton!
    
    @IBOutlet weak var btnOutletSaveEdit: UIButton!
    @IBOutlet weak var btnexpance: UIButton!
    @IBOutlet weak var lblItemNameDisplay: UILabel!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditingRecord == true
        {
            if ( revExpance?[0].isRevenue == 1 )
            {
                btnexpance.isSelected = false
                btnrevenue.isSelected = true
                lblItemNameDisplay.text = "Enter \(btnrevenue.currentTitle!) Name"
            }
            else
            {
                btnrevenue.isSelected = false
                btnexpance.isSelected = true
                lblItemNameDisplay.text = "Enter \(btnexpance.currentTitle!) Name"
            }
            btnOutletSaveEdit.setTitle("Edit", for: .normal)
            txtItemName.text = revExpance?[0].itemName
            txtAmount.text = String((revExpance?[0].amount)!)
            txtDate.text = revExpance?[0].date
        }
        else
        {
            btnrevenue.isSelected = true
            btnexpance.isSelected = false
            lblItemNameDisplay.text = "Enter \(btnexpance.currentTitle!) Name"
            btnOutletSaveEdit.setTitle("Save", for: .normal)
            // Do any additional setup after loading the view.
            
        }
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
        txtItemName.placeholder = "Enter Name"
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
        //dateFormatter.dateFormat = "YYYY-MM-DD HH:MM:SS"
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
        txtDate.text = "\(dateFormatter.string(from: datePicke.date))"
        
        // convert String To Date
        
//        let isoDate = "2016-04-1410:44:00+0000"
//
//         dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX//
//        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ssZ"
//        let date = dateFormatter.date(from:isoDate)!
//
//        print("AAAAAAA:\(date)")
//
//        //date = Date()
//        dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy"
//        let yearString = dateFormatter.string(from: date)
//        print("YEAR:\(yearString)")
        
    }
    func radioUnselectRevAndExp() {
        btnrevenue.isSelected = false
        btnexpance.isSelected = false
    }

    @IBAction func btnActionRevAndExpanceChangeTouchUpInside(_ sender: UIButton) {
        if (!isEditingRecord)
        {
            isRevenue = sender.tag
            txtDate.text = ""
            txtItemName.text = ""
            txtAmount.text = ""
            lblItemNameDisplay.text = "Enter \(sender.currentTitle!) Name"
        }
        radioUnselectRevAndExp()
        sender.isSelected = true
        
    }
    @IBAction func btnActionCalenderTouchUpInside(_ sender: UIButton) {
    }
    
    @IBAction func btnActionSaveTouchUpInside(_ sender: UIButton) {
        if (txtItemName.text != "" && txtDate.text != "" && txtAmount.text != "" )
        {
           if (isEditingRecord)
           {
            if(btnrevenue.isSelected == true)
            {
                isRevenue = 1
            }
            else
            {
                isRevenue = 0
            }
                db.updateByID(itemId: (revExpance?[0].itemId)!, itemName: txtItemName.text!, amount: Int(txtAmount.text!)!, date: txtDate.text!, isrevenue: isRevenue)
            self.navigationController?.popViewController(animated: true)
           }
           else
           {
            var amount : Int = Int(txtAmount.text!)!
            
            print("AMOUNT: =======\(amount)")
            db.insert(itemName: txtItemName.text!, date: txtDate.text!, isRevenue: isRevenue, amount: amount)
            self.navigationController?.popViewController(animated: true)
           }
        }
        else
        {
            print("Item Name, Item Date And Item Amount Is Manadetory")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
