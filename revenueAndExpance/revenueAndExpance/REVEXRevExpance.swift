//
//  REVEXDBClass.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//

import Foundation

class RevExpance
{
    
    
    var itemId: Int = 0
    var itemName: String = ""
    var date: String = ""
    var isRevenue : Int = 0
    var amount : Int = 0
    
    init(itemId:Int, itemName:String, date:String, isRevenue:Int, amount: Int)
    {
        self.itemId = itemId
        self.itemName = itemName
        self.date = date
        self.isRevenue = isRevenue
        self.amount = amount
    }
    
}
