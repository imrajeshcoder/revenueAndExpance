//
//  REVEXDataHelper.swift
//  revenueAndExpance
//
//  Created by Vijay on 10/02/21.
//
import Foundation
import SQLite3

let dbPath: String = "myDb.sqlite"

class DBHelper
{
    var db:OpaquePointer?
    init()
    {
        
    }
    
    func databaseClose()  {
        if sqlite3_close(self.db)  != SQLITE_OK
        {
            print("NOT CLOSE DATABASE")
        }
        else
        {
            print(" SUCCESSFULY CLOSE DATABASE")
        }
    }
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        print(fileURL.path)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
        
    }
    func createTable() {
        //databaseClose()
        db = openDatabase()
        let createTableString = "CREATE TABLE IF NOT EXISTS revexpance (itemid INTEGER PRIMARY KEY AUTOINCREMENT, itemname TEXT, date TEXT, isrevenue INTEGER , amount INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("revexpance table created.")
            } else {
                print("revexpance table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
        databaseClose()
    }
    
    func insert(itemName:String, date: String, isRevenue : Int, amount: Int)
    {
       // databaseClose()
        db=openDatabase()
        let insertStatementString = "INSERT INTO revexpance (itemname, date, isrevenue, amount) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_bind_text(insertStatement, 1, (itemName as NSString).utf8String, -1, nil) != SQLITE_OK { print("Error Binding itemName") }
            if sqlite3_bind_text(insertStatement, 2, (date as NSString).utf8String, -1, nil) != SQLITE_OK { print("Error Binding date") }
            if sqlite3_bind_int(insertStatement, 3, Int32(isRevenue)) != SQLITE_OK { print("Error Binding isRevenue") }
            if sqlite3_bind_int(insertStatement, 4, Int32(amount)) != SQLITE_OK { print("Error Binding amount") }
           
           
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row. " )
                
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                            print("failure inserting hero: \(errmsg)")
                       
                let errCode = sqlite3_errcode(db)
                            print("failure inserting hero: \(errCode)")
                
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        databaseClose()
    }
    func countNoOfItemInDataBase() -> Int
    {
        //databaseClose()
        db=openDatabase()
        let selectStatementString = "select COUNT(itemid) from revexpance;"
        var selectStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatement, nil) == SQLITE_OK
        {
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
              let NoOfItemInTable = sqlite3_column_int(selectStatement, 0)
             // print(" NO OF Q: \(NoOfQuetionInTable)")
          return Int(NoOfItemInTable)
          }
        }
        else
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        databaseClose()
        return 0
    }
    func readAll() -> [RevExpance] {
        //databaseClose()
        db=openDatabase()
        let queryStatementString = "SELECT * FROM revexpance;"
        var queryStatement: OpaquePointer? = nil
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount) ))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        databaseClose()
        return revex
    }
    
    func updateByID(itemId:Int, itemName: String, amount: Int, date: String, isrevenue: Int) {
        db = openDatabase()
        let updateStatementStirng = "UPDATE revexpance SET itemName='\(itemName)', amount=\(amount), date='\(date)', isrevenue=\(isrevenue) WHERE itemid=\(itemId)"
       // let deleteStatementStirng = "DELETE FROM revexpance WHERE itemid =\(itemId) "
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully Update row.")
            } else {
                print("Could not Update row.")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Update statement could not be prepared", errmsg , errno)
        }
        sqlite3_finalize(updateStatement)
        databaseClose()
    }
    func deleteByID(itemId:Int) {
        db = openDatabase()
        let deleteStatementStirng = "DELETE FROM revexpance WHERE itemid =\(itemId) "
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
        databaseClose()
    }
    
    func readOnlyRevenue() -> [RevExpance]
    {
        openDatabase()
        let queryStatementString = "SELECT * FROM revexpance WHERE isrevenue=1"
        var queryStatement: OpaquePointer? = nil
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount) ))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        databaseClose()
        return revex
    }
    
    func readOnlyRevenueOrExpance(isRevenue: Int) -> [RevExpance]
    {
        db=openDatabase()
        let queryStatementString = "SELECT * FROM revexpance WHERE isrevenue=\(isRevenue)"
        var queryStatement: OpaquePointer? = nil
       // sqlite3_bind_int(queryStatement, 1, Int32(isRevenue))
        var revex : [RevExpance] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let itemId = sqlite3_column_int(queryStatement, 0)
                let ItemName = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let isRevenue = sqlite3_column_int(queryStatement, 3)
                let amount = sqlite3_column_int(queryStatement, 4)
                revex.append(RevExpance(itemId: Int(itemId), itemName: ItemName, date: date, isRevenue: Int(isRevenue), amount: Int(amount) ))
                print("Query Result:")
                print("\(itemId) | \(ItemName) | \(date) | \(isRevenue)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        databaseClose()
        return revex
    }
    
}
